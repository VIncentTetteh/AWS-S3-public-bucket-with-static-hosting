provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "static" {
  bucket = "your-bucket-name"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject"
        ]
        Resource = [
          "${aws_s3_bucket.static.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_s3_bucket_object" "index" {
  bucket = aws_s3_bucket.static.id
  key    = "index.html"
  content_type = "text/html"
  source = "index.html"
}

resource "aws_s3_bucket_object" "error" {
  bucket = aws_s3_bucket.static.id
  key    = "error.html"
  content_type = "text/html"
  source = "error.html"
}

output "s3_bucket_endpoint" {
  value = "http://${aws_s3_bucket.static.website_endpoint}"
}
