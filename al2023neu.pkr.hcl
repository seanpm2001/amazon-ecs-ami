locals {
  ami_name_al2023neu = "${var.ami_name_prefix_al2023}-neuron-hvm-2023.0.${var.ami_version}${var.kernel_version_al2023}-x86_64"
}

source "amazon-ebs" "al2023neu" {
  ami_name        = "${local.ami_name_al2023neu}"
  ami_description = "Amazon Linux AMI 2023.0.${var.ami_version} x86_64 ECS HVM EBS"
  instance_type   = var.neu_instance_types[0]
  launch_block_device_mappings {
    volume_size           = var.block_device_size_gb
    delete_on_termination = true
    volume_type           = "gp3"
    device_name           = "/dev/xvda"
  }
  region = var.region
  source_ami_filter {
    filters = {
      name = "${var.source_ami_al2023}"
    }
    owners      = ["amazon"]
    most_recent = true
  }
  ssh_interface = "public_ip"
  ssh_username  = "ec2-user"
  tags = {
    os_version          = "Amazon Linux 2023"
    source_image_name   = "{{ .SourceAMIName }}"
    ecs_runtime_version = "Docker version ${var.docker_version_al2023}"
    ecs_agent_version   = "${var.ecs_agent_version}"
    ami_type            = "al2023neu"
    ami_version         = "2023.0.${var.ami_version}"
  }
}

