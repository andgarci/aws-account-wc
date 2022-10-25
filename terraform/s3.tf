resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = local.pipeline.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "codepipeline_bucket_ownership" {
  bucket = aws_s3_bucket.codepipeline_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
