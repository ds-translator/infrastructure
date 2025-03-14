
resource "aws_launch_template" "custom_template" {
  name = "${var.project_id}-eks-node-template"


#   block_device_mappings {
#     device_name = "/dev/xvda" # Adjust if your AMI uses a different device name
#     ebs {
#       volume_size = 20    # Specify the disk size in GiB
#       volume_type = "gp2" # You can also choose "gp3", "io1", etc.
#       # Optionally, add other settings like delete_on_termination, iops, etc.
#     }
#   }

  metadata_options {
    http_put_response_hop_limit = 2
  }
}

resource "aws_launch_template" "custom_gpu_template" {
  name = "${var.project_id}-eks-node-template-gpu"


  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 80
    }
  }

#   block_device_mappings {
#     device_name = "/dev/xvda" # Adjust if your AMI uses a different device name
#     ebs {
#       volume_size = 20    # Specify the disk size in GiB
#       volume_type = "gp2" # You can also choose "gp3", "io1", etc.
#       # Optionally, add other settings like delete_on_termination, iops, etc.
#     }
#   }

  metadata_options {
    http_put_response_hop_limit = 2
  }
}
