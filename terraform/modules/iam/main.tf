variable "project_name" { type = string }

# IAM a privilege minimal : un utilisateur par tier, avec le role strict necessaire.
# Le mot de passe genere est un output sensible, jamais ecrit en clair dans le code.

resource "openstack_identity_user_v3" "presentation" {
  name = "${var.project_name}-presentation-svc"
}

resource "openstack_identity_user_v3" "application" {
  name = "${var.project_name}-application-svc"
}

resource "openstack_identity_user_v3" "data" {
  name = "${var.project_name}-data-svc"
}

output "user_ids" {
  value = {
    presentation = openstack_identity_user_v3.presentation.id
    application  = openstack_identity_user_v3.application.id
    data         = openstack_identity_user_v3.data.id
  }
}
