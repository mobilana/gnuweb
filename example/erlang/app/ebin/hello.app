
{application, hello,
   [
      {description, "hello"},
      {vsn,         "0.0"},
      {modules,     [he,lo,hello_app]},
      {registered,  []},
      {applications,[kernel,stdlib]},
      {mod, {hello_app, []}},
      {env, [
	{'PACKAGE_URL', ""},
	{'PACKAGE', "example-erlang"},
	{'PACKAGE_BUGREPORT', "dev@mobi-lana.com"},
	{'PACKAGE_STRING', "example-erlang 0.0"},
	{'VERSION', "0.0"},
	{'PACKAGE_VERSION', "0.0"},
	{'PACKAGE_TARNAME', "example-erlang"},
	{'PACKAGE_NAME', "example-erlang"}
      ]}
   ]
}.  

