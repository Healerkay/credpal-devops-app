########################################
# GitHub OIDC Provider
########################################
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]
}

########################################
# IAM Role for GitHub Actions (ECS Deploy)
########################################
resource "aws_iam_role" "github_actions_ecs" {
  name = "GitHubActionsECSDeployRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:Healerkay/credpal-devops-app:*"
          }
        }
      }
    ]
  })
}

########################################
# Permissions for GitHub Actions Role
########################################
resource "aws_iam_role_policy_attachment" "ecs_full_access" {
  role       = aws_iam_role.github_actions_ecs.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_iam_role_policy_attachment" "iam_read_only" {
  role       = aws_iam_role.github_actions_ecs.name
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}