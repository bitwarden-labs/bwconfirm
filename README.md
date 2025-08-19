# Description

Onboarding Organization members always requires an administrative session to [Confirm](https://bitwarden.com/help/managing-users/#confirm) the user to the Organization, after the Organization invitation has been accepted by the user. This encryption step is required for users to have access to share data in the Organization. This repository holds a Dockerized application for automating the Confirm step.

# Security Warning

Before administering the confirm command, it is strongly advised that administrators validate the legitimacy of a request by ensuring that the fingerprint phrase self-reported by the user matches the fingerprint phrase associated with the user you expect to be confirmed. The headless nature of this script does not print the fingerprint phrase, and will automatically Confirm all Member objects in a Needs Confirmation status in the Organization.

Once a user is confirmed, they have the ability to decrypt organization data, so ensuring users' self-reported fingerprint phrases match expected values is an important step prior to confirming.

Only automate this step if you have other compensating controls, such as Login with SSO and Conditional Access Policies that supercede the Bitwarden fingerprint identity verification process.
