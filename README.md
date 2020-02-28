# Sandbox User Initialization

Sandbox initialization class that creates admin users based on custom metadata from production.

## Installation

Deploy this project to a non source-tracked org (sandbox or production) with the following Salesforce CLI command:
```
sfdx force:source:deploy -p src -u myTargetOrgAlias
```

## Usage
1. Go to **Setup > Custom Code > Custom Metadata Types** on the production org.
1. Click **Manage Records** for the	**Sandbox User** type.
1. Click **New** and add one or more users with those fields:

  | Field | Description |
  |-------|-------------|
  | Label | Just an alias visible in production org's metadata record list |
  | Sandbox User Name | Just an alias visible in production org's metadata record list. This doesn't have to be in an email format, __it's not the actual sanbox username__. |
  | Base Username | The base part of the sandbox username. We'll add `.sanboxName` to this base when we generate the sandbox user. If you enter `codey@example.com` as the base username and you create a `devSbx` sandbox, we'll create a `codey@example.com.devSbx` user. |
  | Email | The email address associated with the user. The user password needs to be set so we'll send a welcome email to that address. |