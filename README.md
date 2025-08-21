# Description

Onboarding Organization members always requires an administrative session to [Confirm](https://bitwarden.com/help/managing-users/#confirm) the user to the Organization, after the Organization invitation has been accepted by the user. This encryption step is required for users to have access to share data in the Organization. This repository holds a Dockerized application for automating the Confirm step.

# Security Warning

Before administering the confirm command, it is strongly advised that administrators validate the legitimacy of a request by ensuring that the fingerprint phrase self-reported by the user matches the fingerprint phrase associated with the user you expect to be confirmed. The headless nature of this script does not print the fingerprint phrase, and will automatically Confirm all Member objects in a Needs Confirmation status in the Organization.

Once a user is confirmed, they have the ability to decrypt organization data, so ensuring users' self-reported fingerprint phrases match expected values is an important step prior to confirming.

Only automate this step if you have other compensating controls, such as Login with SSO and Conditional Access Policies that supercede the Bitwarden fingerprint identity verification process.

# Example Configuration

Select an Admin, Owner, or Custom role with the Manage Users permission. Log in to the Bitwarden Web App, navigate to Settings -> Security -> Keys, and view your API credentials.

## Required Configuration
| Var Name | Value |
| ------------- | ------------- |
| BW_CLIENTID  | Your [user-level Public API ID](https://bitwarden.com/help/personal-api-key/) |
| BW_CLIENTSECRET | Your [user-level Public API Secret](https://bitwarden.com/help/personal-api-key/) |
| organization_id | Your [Organization ID](https://bitwarden.com/help/cli/#organization-ids) |
| p0 | A base64-encoded representation of your Master Password |
## Optional Configuration
| Var Name | Value |
| ------------- | ------------- |
| set_server_url | Whether you wish to specify a Bitwarden Server URL (default: US Cloud) |
| bw_server_url | Your Bitwarden Server URL, if not default |
## Running
The container is designed to run and exit, not run and stay running in a loop, suitable for cron jobs, Scheduled Tasks, etc. When running on a schedule, it is recommended to attach persistent storage for the `/root/.config/Bitwarden CLI` directory for optimal execution.

### Docker

```
docker run \
--env BW_CLIENTID=user.114cd4b6-7d4d-11f0-8e4a-f7a42f0fcb66 \
--env BW_CLIENTSECRET=asdfpoi350dASDF93548fgvsdfjISE \
--env organization_id=37ea8d20-7d4d-11f0-9258-9741a6ea35ee \
--env p0='bm8gdGhhbmtzCg==' \
--env set_server_url=1 \
--env bw_server_url=https://vault.bitwarden.eu \
-v $(pwd)/config:/root/.config \
-it ghcr.io/bitwarden-labs/bwconfirm:main
```

### Kubernetes

As long as the `env` data gets into the container as an environment variable, you may use any method to provide these variables - `env` is used for illustrative purposes.

```
apiVersion: batch/v1
kind: CronJob
metadata:
  name: bwconfirm
  namespace: bitwarden
spec:
  schedule: '@hourly'
  concurrencyPolicy: Forbid
  jobTemplate:
    spec:
      template:
        spec:
          containers:
            - name: bwconfirm
              image: ghcr.io/bitwarden-labs/bwconfirm:main
              command:
              - "/bin/bash"
              args:
              - ["c", "/bwConfirm.sh"]
              env:
              - name: BW_CLIENTID
                value: "user.84a9f5f5-0b27-488c-92a3-ad8300fdca1b"
              - name: BW_CLIENTSECRET
                value: "rOsmh8Lx7PwG0AOEGQWyFJudXfaCUE"
              - name: organization_id
                value: "4374263a-ba1a-4d69-a8d3-ad550120f215"
              - name: p0
                value: "S0t6aFBlTDRvTURhWFYK"
              - name: BITWARDENCLI_APPDATA_DIR
                value: "/var/tmp/"
              volumeMounts:
              - mountPath: /var/tmp
                name: bwconfirm-config
          volumes:
          - name: bwconfirm-config
            emptyDir:
              sizeLimit: 100Mi
          restartPolicy: OnFailure
```
