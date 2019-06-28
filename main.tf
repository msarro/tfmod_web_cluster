# Web Server Cluster
resource "aws_launch_configuration" "web_cluster" {
  image_id        = "${var.ami}"
  instance_type   = "${var.instance_type}"
  security_groups = ["${var.web_security_groups}"]
  key_name        = "${var.key_name}"

  user_data = "${var.user_data}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web_cluster" {
  launch_configuration = "${aws_launch_configuration.web_cluster.id}"

  vpc_zone_identifier = ["${var.subnet_ids}"]

  load_balancers    = ["${aws_elb.web_cluster_elb.id}"]
  health_check_type = "ELB"

  min_size         = "${var.min_cluster_size}"
  max_size         = "${var.max_cluster_size}"
  desired_capacity = "${var.preferred_cluster_size}"

  tag {
    key                 = "Name"
    value               = "web_cluster_${var.environment}"
    propagate_at_launch = true
  }
}

resource "aws_elb" "web_cluster_elb" {
  name            = "web-cluster-elb-${var.environment}"
  security_groups = ["${var.web_security_groups}"]
  subnets         = ["${var.subnet_ids}"]

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }

/*   listener {
    lb_port           = 443
    lb_protocol       = "https"
    instance_port     = 80
    instance_protocol = "http"
  }
 */
  health_check {
    healthy_threshold   = 4
    unhealthy_threshold = 4
    timeout             = 3
    interval            = 30
    target              = "HTTP:80/"
  }
}
