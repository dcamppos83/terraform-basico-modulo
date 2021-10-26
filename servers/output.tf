output "ip_address" {
  //essa forma é para ser usada com count
  // com o foreach nao acessamos este índice
  value = aws_instance.web[*].public_ip

  //foreach
  # value = {
  #   for instance in aws_instance.web:
  #   instance.id => instance.private_ip
  # }
}

# output "ip_address" {
#   value = aws_instance.web-west[*].public_ip
# }