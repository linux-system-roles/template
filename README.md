# Role Name

[![ansible-lint.yml](https://github.com/linux-system-roles/template/actions/workflows/ansible-lint.yml/badge.svg)](https://github.com/linux-system-roles/template/actions/workflows/ansible-lint.yml) [![ansible-test.yml](https://github.com/linux-system-roles/template/actions/workflows/ansible-test.yml/badge.svg)](https://github.com/linux-system-roles/template/actions/workflows/ansible-test.yml) [![codespell.yml](https://github.com/linux-system-roles/template/actions/workflows/codespell.yml/badge.svg)](https://github.com/linux-system-roles/template/actions/workflows/codespell.yml) [![markdownlint.yml](https://github.com/linux-system-roles/template/actions/workflows/markdownlint.yml/badge.svg)](https://github.com/linux-system-roles/template/actions/workflows/markdownlint.yml) [![qemu-kvm-integration-tests.yml](https://github.com/linux-system-roles/template/actions/workflows/qemu-kvm-integration-tests.yml/badge.svg)](https://github.com/linux-system-roles/template/actions/workflows/qemu-kvm-integration-tests.yml) [![shellcheck.yml](https://github.com/linux-system-roles/template/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/linux-system-roles/template/actions/workflows/shellcheck.yml) [![tft.yml](https://github.com/linux-system-roles/template/actions/workflows/tft.yml/badge.svg)](https://github.com/linux-system-roles/template/actions/workflows/tft.yml) [![tft_citest_bad.yml](https://github.com/linux-system-roles/template/actions/workflows/tft_citest_bad.yml/badge.svg)](https://github.com/linux-system-roles/template/actions/workflows/tft_citest_bad.yml) [![woke.yml](https://github.com/linux-system-roles/template/actions/workflows/woke.yml/badge.svg)](https://github.com/linux-system-roles/template/actions/workflows/woke.yml)

![template](https://github.com/linux-system-roles/template/workflows/tox/badge.svg)

A template for an ansible role that configures some GNU/Linux subsystem or
service. A brief description of the role goes here.

## Requirements

Any prerequisites that may not be covered by Ansible itself or the role should
be mentioned here.  This includes platform dependencies not managed by the
role, hardware requirements, external collections, etc.  There should be a
distinction between *control node* requirements (like collections) and
*managed node* requirements (like special hardware, platform provisioning).

### Collection requirements

For instance, if the role depends on some collections and has a
`meta/collection-requirements.yml` file for installing those dependencies, and
in order to manage `rpm-ostree` systems, it should be mentioned here that the
 user should run

```bash
ansible-galaxy collection install -vv -r meta/collection-requirements.yml
```

on the *control node* before using the role.

## Role Variables

Validation is enforced by `meta/argument_specs.yml`.

A description of all input variables (i.e. variables that are defined in
`defaults/main.yml`) for the role should go here as these form an API of the
role.  Each variable should have its own section e.g.

### template_foo

A string variable for the foo setting.
The default value is `"foo"`.

### template_bar

A boolean variable that enables or disables the bar feature.
The default value is `true`.

### template_baz

An integer variable for a numeric setting.
The default value is `0`.

### template_config_path

Filesystem path to the configuration file.
The default value is `"/etc/template.conf"`.

### template_state

Desired state of the template subsystem.  Must be one of `enabled`
or `disabled`.  The default value is `"enabled"`.

### template_packages

A list of package names (strings).
The default value is `[]`.

### template_raw_value

A variable that accepts values of different types (e.g. a string or a list).
The default value is `""`.

### template_services

A list of service configurations.  Each entry is a dictionary with the
following keys:

| Key | Type | Required | Description |
|-----|------|----------|-------------|
| `name` | str | yes | Name of the service. |
| `type` | str | no | Type of the service.  One of `simple`, `forking`, `oneshot`. |
| `enabled` | bool | no | Whether the service should be enabled at boot. |

The default value is `[]`.

Variables that are not intended as input, like variables defined in
`vars/main.yml`, variables that are read from other roles and/or the global
scope (ie. hostvars, group vars, etc.) can be also mentioned here but keep in
mind that as these are probably not part of the role API they may change during
the lifetime.

Example of setting the variables:

```yaml
template_foo: "oof"
template_bar: false
template_baz: 42
template_config_path: /etc/myapp/config.yml
template_state: disabled
template_packages:
  - vim
  - tmux
template_raw_value:
  - first
  - second
template_services:
  - name: httpd
    type: forking
    enabled: true
  - name: my-worker
    type: simple
```

## Variables Exported by the Role

This section is optional.  Some roles may export variables for playbooks to
use later.  These are analogous to "return values" in Ansible modules.  For
example, if a role performs some action that will require a system reboot, but
the user wants to defer the reboot, the role might set a variable like
`template_reboot_needed: true` that the playbook can use to reboot at a more
convenient time.

Example:

### template_reboot_needed

Default `false` - if `true`, this means a reboot is needed to apply the changes
made by the role

## Example Playbook

Including an example of how to use your role (for instance, with variables
passed in as parameters) is always nice for users too:

```yaml
- name: Manage the template subsystem
  hosts: all
  vars:
    template_foo: "foo foo!"
    template_bar: false
    template_baz: 42
    template_state: disabled
    template_services:
      - name: httpd
        type: forking
        enabled: true
  roles:
    - linux-system-roles.template
```

More examples can be provided in the [`examples/`](examples) directory. These
can be useful, especially for documentation.

## rpm-ostree

See README-ostree.md

## License

Whenever possible, please prefer MIT.

## Author Information

An optional section for the role authors to include contact information, or a
website (HTML is not allowed).
