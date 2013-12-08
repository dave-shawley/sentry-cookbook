@test "sentry user created" {
	getent passwd sentry
	test "$(id -Gn sentry)" = "daemon"
}

@test "sentry group created" {
  getent group sentry
}

@test "sentry virtualenv exists" {
  test -d /opt/sentry
  test -e /opt/sentry/bin/activate
  test -x /opt/sentry/bin/python
  test "$(stat --printf='%U:%G' /opt/sentry)" = "sentry:sentry"
}
