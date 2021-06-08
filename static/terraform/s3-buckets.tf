resource "aws_s3_bucket" "staging_bucket" {
  provider = aws 
  bucket   = "eessi-staging"
  policy   = data.aws_iam_policy_document.public_read_s3.json
  acl      = "private"

  tags = {
    Name = "EESSI staging bucket",
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "staging-log/"
  }

  lifecycle_rule {
    id      = "layers"
    enabled = true

#    prefix = "/"

    tags = {
      rule      = "layers"
      autoclean = "true"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA" # or "ONEZONE_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = 90
    }
  }
}

data "aws_iam_policy_document" "public_read_s3" {
  provider  = aws 

  statement {
    sid = "public-read"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:GetObjectVersion",
    ]

    resources = [
      "arn:aws:s3:::eessi-staging",
      "arn:aws:s3:::eessi-staging/*",
    ]

    principals {
      type = "AWS"
      identifiers = [ "*" ]
    }
  }

  statement {
    sid = "admin-access"
    effect = "Allow"
    actions = [ "s3:*" ]

    resources = [
      "arn:aws:s3:::eessi-staging",
      "arn:aws:s3:::eessi-staging/*",
    ]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::341349732686:user/tkvernes",
        "arn:aws:iam::341349732686:user/khoste",
        "arn:aws:iam::341349732686:user/hjzilverberg",
        "arn:aws:iam::341349732686:user/bedroge"
       ]
    }
  }

  statement {
    sid = "allow-vpce"
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketLocation",
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]
    effect = "Allow"
    resources = [
      "arn:aws:s3:::eessi-staging",
      "arn:aws:s3:::eessi-staging/*",
    ]
    condition {
      test = "StringEquals"
      variable = "aws:SourceVpce"
      # Dynamic, Static
      values = [ "vpce-05d0f283320f5cd79", "vpce-017b47a4e23686462" ]
    }
    principals {
      type = "AWS"
      identifiers = [ "*" ]
    }
  }
}

resource "aws_s3_bucket" "log_bucket" {
  provider = aws 
  bucket   = "eessi-logs"
  policy   = data.aws_iam_policy_document.admin_only.json
  acl      = "log-delivery-write"

  tags = {
    Name = "EESSI logging bucket",
  }

  lifecycle_rule {
    id      = "layers"
    enabled = true

#    prefix = "/"

    tags = {
      rule      = "layers"
      autoclean = "true"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA" # or "ONEZONE_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }
}

data "aws_iam_policy_document" "admin_only" {
  provider  = aws 

  statement {
    sid = "admin-access"
    effect = "Allow"
    actions = [ "s3:*" ]

    resources = [
      "arn:aws:s3:::eessi-logs",
      "arn:aws:s3:::eessi-logs/*",
    ]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::341349732686:user/tkvernes",
        "arn:aws:iam::341349732686:user/khoste",
        "arn:aws:iam::341349732686:user/hjzilverberg",
        "arn:aws:iam::341349732686:user/bedroge"
       ]
    }
  }
}

data "aws_iam_policy_document" "gentoo_snapshot_access" {
  provider  = aws 

  statement {
    sid = "public-read"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:GetObjectVersion",
    ]

    resources = [
      "arn:aws:s3:::eessi-gentoo-snapshot",
      "arn:aws:s3:::eessi-gentoo-snapshot/*",
    ]

    principals {
      type = "AWS"
      identifiers = [ "*" ]
    }
  }

  statement {
    sid = "admin-access"
    effect = "Allow"
    actions = [ "s3:*" ]

    resources = [
      "arn:aws:s3:::eessi-gentoo-snapshot",
      "arn:aws:s3:::eessi-gentoo-snapshot/*",
    ]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::341349732686:user/tkvernes",
        "arn:aws:iam::341349732686:user/khoste",
        "arn:aws:iam::341349732686:user/hjzilverberg",
        "arn:aws:iam::341349732686:user/bedroge"
       ]
    }
  }
}

resource "aws_s3_bucket" "gentoo_snapshot_bucket" {
  provider = aws 
  bucket   = "eessi-gentoo-snapshot"
  policy   = data.aws_iam_policy_document.gentoo_snapshot_access.json
  acl      = "private"

  tags = {
    Name = "EESSI gentoo snapshot bucket",
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "gentoo-snapshot-log/"
  }

  lifecycle_rule {
    id      = "layers"
    enabled = true

#    prefix = "/"

    tags = {
      rule      = "layers"
      autoclean = "true"
    }

    transition {
      days          = 90
      storage_class = "STANDARD_IA" # or "ONEZONE_IA"
    }

    transition {
      days          = 180
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }
}


#resource "aws_iam_policy" "s3_static_bucket_policy" {
#  name   = "s3_static_bucket_policy"
#  path   = "/"
#  policy = data.aws_iam_policy_document.public_read_s3.json
# }
