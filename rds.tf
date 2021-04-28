resource "aws_db_subnet_group" "oracle-subnet" {
  name        = "oracle-subnet"
  description = "RDS subnet group"
  subnet_ids  = [aws_subnet.main-private-1.id, aws_subnet.main-private-2.id]
}

resource "aws_db_parameter_group" "oracle-parameters" {
  name        = "oracle-parameters"
  family      = "oracle19.0"
  description = "oracleDB parameter group"

  parameter {
    name  = "max_allowed_packet"
    value = "16777216"
  }
}

resource "aws_db_instance" "oracledb" {
  allocated_storage       = 20 # 100 GB of storage, gives us more IOPS than a lower number
  engine                  = "oracle-ee"
  engine_version          = "19.0.0"
  instance_class          = "db.m5.large" # use micro if you want to use the free tier
  identifier              = "oracledb"
  name                    = "awsiroracle01np"
  username                = "root"           # username
  password                = var.RDS_PASSWORD # password
  db_subnet_group_name    = aws_db_subnet_group.oracle-subnet.name
  parameter_group_name    = aws_db_parameter_group.oracle-parameters.name
  multi_az                = "false" # set to true to have high availability: 2 instances synchronized with each other
  vpc_security_group_ids  = [aws_security_group.allow-oracle.id]
  storage_type            = "gp2"
  availability_zone       = aws_subnet.main-private-1.availability_zone # prefered AZ
  tags = {
    Name = "oracle-instance"
  }
}

