export CLIENT_ID=ApplicationID       #  Update with you existing application id from environment details page
export CLIENT_SECRET=Applicationsecret    # Update with you existing application secret from environment details page
export ISSUER_URI=https://login.microsoftonline.com/TenantID/v2.0        # Make sure to replace TenantID with your tenant ID
export JWK_SET_URI=https://login.microsoftonline.com/TenantID/discovery/v2.0/keys # Make sure to replace TenantID with your tenant ID

      # Your SSO Provider Json Web Token URI  # Make sure to replace TenantID with your tenant ID
export SCOPE=openid,profile,email
