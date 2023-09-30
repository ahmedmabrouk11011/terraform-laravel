#########################################
# EC2 Custom Policies
#########################################


# Create an IAM role for the ec2 instance to use SSM
resource "aws_iam_role" "ssm_role" {
  name = "ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the SSM policy to the IAM role
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Create an instance profile for the IAM role
resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ssm-profile"
  role = aws_iam_role.ssm_role.name
}

#########################################
# Security Group
#########################################

resource "aws_security_group" "ec2_sg" {
  # loop
  for_each = {
    for key, value in var.ec2s :
    key => value
  }

  # basic settings
  name = join("-", [
    each.value.name,
    var.environment,
    "sg"
  ])
  description = join(" ", [
    "Security group for EC2",
    join("-", [
      each.value.name,
    var.environment])
  ])
  vpc_id = aws_vpc.main.id

  # ingress rules to allow traffic on port 22 and 80 from the public
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access from the public"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access from the public"
  }

  # egress rules to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  # terraform
  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/template/laravel-deployment.sh")
}

# Shuffle the public subnet ids
resource "random_shuffle" "public_subnet" {
  input = values(aws_subnet.public).*.id
}


#########################################
# Instance
#########################################
# Create an ec2 instance with the SSM role and the user data file
resource "aws_instance" "laravel_ec2" {

  # loop
  for_each = {
    for key, value in var.ec2s :
    key => value
  }

  ami                  = each.value.instance_ami
  instance_type        = each.value.instance_type
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
  user_data            = data.template_file.user_data.rendered
  subnet_id            = random_shuffle.public_subnet.result[0]

  vpc_security_group_ids = [aws_security_group.ec2_sg[each.key].id]

  tags = merge({
    Name = join("-", [
      each.value.name,
      var.environment
    ])
  }, var.tags)
}
