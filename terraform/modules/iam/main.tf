# IAM à privilège minimal : un utilisateur de service par tier.
resource "openstack_identity_user_v3" "presentation" {
  name = "${var.project_name}-presentation-svc"
}

resource "openstack_identity_user_v3" "application" {
  name = "${var.project_name}-application-svc"
}

resource "openstack_identity_user_v3" "data" {
  name = "${var.project_name}-data-svc"
}
