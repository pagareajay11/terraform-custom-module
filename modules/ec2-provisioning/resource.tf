
resource "aws_iam_role" "ec2_s3_access_role" {
  name               = "s3-role"
  assume_role_policy = "${file("assumerolepolicy.json")}"
}
resource "aws_iam_policy" "policy" {
  name        = "test-policy"
  description = "A test policy"
  policy      = "${file("policys3bucket.json")}"
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  roles      = ["${aws_iam_role.ec2_s3_access_role.name}"]
  policy_arn = "${aws_iam_policy.policy.arn}"
}

resource "aws_iam_instance_profile" "test_profile" {
  name  = "test_profile"
  role = "${aws_iam_role.ec2_s3_access_role.name}"
}

resource "aws_instance" "server" {
  instance_type = var.instance_type
  ami = var.image_id
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  subnet_id = aws_subnet.subnet-1.id

  iam_instance_profile = aws_iam_instance_profile.test_profile.id
  associate_public_ip_address = true
  tags ={
    Name = "app-server-1"
  }
}

