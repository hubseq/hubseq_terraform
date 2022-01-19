resource "aws_ecr_repository" "testrepo" {
  name                 = "testrepo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-ecr-testrepo" })
}

resource "aws_ecr_repository" "bwamem" {
  name                 = "bwamem"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-ecr-bwamem" })
}

resource "aws_ecr_repository" "bwamem_bam" {
  name                 = "bwamem_bam"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-ecr-bwamem-bam" })
}

resource "aws_ecr_repository" "bcl2fastq" {
  name                 = "bcl2fastq"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-ecr-bcl2fastq" })
}

resource "aws_ecr_repository" "mpileup" {
  name                 = "mpileup"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-ecr-mpileup" })
}

resource "aws_ecr_repository" "fastqc" {
  name                 = "fastqc"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-ecr-fastqc" })
}

resource "aws_ecr_repository" "varscan2" {
  name                 = "varscan2"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-ecr-varscan2" })
}
