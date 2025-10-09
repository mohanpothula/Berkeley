resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "private-subnet-${count.index}"
    "kubernetes.io/role/internal-elb" = "1"
  }
}
