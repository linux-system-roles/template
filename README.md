# template role -- Basic template for Linux system roles

- [Entry point `main` -- Basic template for Linux system roles](#entry-point-main----basic-template-for-linux-system-roles)

  - [Synopsis](#synopsis)

  - [Parameters](#parameters)

  - [Attributes](#attributes)

  - [Notes](#notes)

  - [Examples](#examples)

  - [Return Variables](#return-variables)

  - [Authors](#authors)

## Entry point `main` -- Basic template for Linux system roles

### Synopsis

- One or more sentences describing what the role does.

### Parameters

| Parameter                                          | Comments |
| -------------------------------------------------- | --- |
| **template_bar** *boolean*                         | A boolean variable that enables or disables the bar feature. **Choices:** `false`, `true` (default) |
| **template_baz** *integer*                         | An integer variable for a numeric setting. **Default:** `0` |
| **template_config_path** *path*                    | Filesystem path to the configuration file, for example `/etc/template.conf`. **Default:** `"/etc/template.conf"` |
| **template_foo** *string*                          | A string variable for the foo setting. **Default:** `"foo"` |
| **template_packages** *list / elements=string*     | A list of package names. Use elements to declare the type of each item in the list. **Default:** `[]` |
| **template_raw_value** *any*                       | A variable that accepts values of different types. Use raw when the variable can be either a string or a list, for example. **Default:** `""` |
| **template_services** *list / elements=dictionary* | A list of service configurations. Each entry is a dictionary with its own set of options. Use this pattern when the role takes a list of structured items. **Default:** `[]` |
| - **enabled** *boolean*                            | Whether the service should be enabled at boot. **Choices:** `false`, `true` (default) |
| - **name** *string / required*                     | Name of the service. Mark a sub-option as required when it must always be provided. |
| - **type** *string*                                | Type of the service. Choices work inside nested options the same way as at the top level. **Choices:** `"simple"`, `"forking"`, `"oneshot"` |
| **template_state** *string*                        | Desired state of the template subsystem. Use choices to restrict a string variable to a fixed set of allowed values, such as `enabled` or `disabled`. **Choices:** `"enabled"` (default), `"disabled"` |

### Attributes

| Attribute      | Support                                                           | Description |
| -------------- | ----------------------------------------------------------------- | --- |
| **check_mode** | **full**                                                          | Whether the role can run in check mode. |
| **idempotent** | **full**                                                          | Whether a second run with the same arguments reports no change. |
| **platforms**  | **full** `Fedora` `RHEL` and compatible Enterprise Linux 9 and 10 | Target operating systems. |

### Notes

- A technical detail that does not belong in any single option's description.

### Examples

```yaml
- name: Describe what this example play does
  hosts: all
  vars:
    template_foo: custom-value
    template_state: enabled
  roles:
    - linux-system-roles.template
```

### Return Variables

The following variables are set by this role:

| Key                                     | Description |
| --------------------------------------- | --- |
| **template_returned_variable** *string* | What this variable holds and when the role sets it. **Returned:** always **Sample:** `"example-value"` |

### Authors

- Your Name (@yourhandle)
