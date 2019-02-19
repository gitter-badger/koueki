defmodule Koueki.Validation.Type do
  alias Ecto.{
    Changeset
  }

  @doc """
  Get the list of valid types for a given category
  """
  def valid_types(category) do
    case category do
      "Antivirus detection" ->
        ~w[link comment text hex attachment other anonymised]

      "Artifacts dropped" ->
        ~w[md5 sha1 sha224 sha256 sha384 sha512 sha512/224 sha512/256
          ssdeep imphash impfuzzy authentihash cdhash filename
          filename|md5 filename|sha1 filename|sha224 filename|sha256
          filename|sha384 filename|sha512 filename|sha512/224
          filename|sha512/256 filename|authentihash filename|ssdeep
          filename|tlsh filename|imphash filename|impfuzzy
          filename|pehash regkey regkey|value pattern-in-file
          pattern-in-memory pdb stix2-pattern yara sigma
          attachment malware-sample
          named-pipe mutex windows-scheduled-task windows-service-name
          windows-service-displayname comment text hex
          x509-fingerprint-sha1 x509-fingerprint-md5
          x509-fingerprint-sha256 other cookie gene mime-type anonymised]

      "Attribution" ->
        ~w[threat-actor campaign-name campaign-id whois-registrant-phone
          whois-registrant-email whois-registrant-name whois-registrant-org
          whois-registrar whois-creation-date comment text
          x509-fingerprint-sha1 x509-fingerprint-md5 x509-fingerprint-sha256
          other dns-soa-email anonymised]

      "External analysis" ->
        ~w[md5 sha1 sha256 filename filename|md5 filename|sha1
          filename|sha256 ip-src ip-dst ip-dst|port ip-src|port mac-address
          mac-eui-64 hostname domain domain|ip url user-agent
          regkey regkey|value AS snort bro zeek pattern-in-file
          pattern-in-traffic pattern-in-memory vulnerability attachment
          malware-sample link comment text x509-fingerprint-sha1
          x509-fingerprint-md5 x509-fingerprint-sha256 ja3-fingerprint-md5
          hassh-md5 hasshserver-md5 github-repository other cortex
          anonymised]

      "Financial fraud" ->
        ~w[btc xmr iban bic bank-account-nr aba-rtn bin cc-number
          prtn phone-number comment text other hex anonymised]

      "Internal reference" ->
        ~w[text link comment other hex anonymised]

      "Network activity" ->
        ~w[ip-src ip-dst ip-dst|port ip-src|port port hostname domain
          domain|ip mac-address mac-eui-64 email-dst url uri user-agent
          http-method AS snort pattern-in-file stix2-pattern
          pattern-in-traffic attachment comment text x509-fingerprint-md5
          x509-fingerprint-sha1 x509-fingerprint-sha256 ja3-fingerprint-md5
          hassh-md5 hasshserver-md5 other hex cookie hostname|port bro zeek anonymised]

      "Other" ->
        ~w[comment text other size-in-bytes counter datetime cpe port
          float hex phone-number boolean anonymised]

      "Payload delivery" ->
        ~w[md5 sha1 sha224 sha256 sha384 sha512 sha512/224 sha512/256
          ssdeep imphash impfuzzy authentihash pehash tlsh cdhash
          filename filename|md5 filename|sha1 filename|sha224
          filename|sha256 filename|sha384 filename|sha512
          filename|sha512/224 filename|sha512/256 filename|authentihash
          filename|ssdeep filename|tlsh filename|imphash
          filename|impfuzzy filename|pehash mac-address mac-eui-64 ip-src
          ip-dst ip-dst|port ip-src|port hostname domain email-src
          email-dst email-subject email-attachment email-body url
          user-agent AS pattern-in-file pattern-in-traffic
          stix2-pattern yara sigma mime-type attachment malware-sample
          link malware-type comment text hex vulnerability
          x509-fingerprint-sha1 x509-fingerprint-md5 x509-fingerprint-sha256
          ja3-fingerprint-md5 hassh-md5 hasshserver-md5 other
          hostname|port email-dst-display-name email-src-display-name
          email-header email-reply-to email-x-mailer email-mime-boundary
          email-thread-index email-message-id mobile-application-id
          whois-registrant-email anonymised]

      "Payload installation" ->
        ~w[md5 sha1 sha224 sha256 sha384 sha512 sha512/224 sha512/256
          ssdeep imphash impfuzzy authentihash pehash tlsh cdhash
          filename filename|md5 filename|sha1 filename|sha224
          filename|sha256 filename|sha384 filename|sha512
          filename|sha512/224 filename|sha512/256 filename|authentihash
          filename|ssdeep filename|tlsh filename|imphash
          filename|impfuzzy filename|pehash pattern-in-file pattern-in-traffic
          pattern-in-memory stix2-pattern yara sigma
          vulnerability attachment malware-sample malware-type comment
          text hex x509-fingerprint-sha1 x509-fingerprint-md5
          x509-fingerprint-sha256 mobile-application-id other mime-type
          anonymised]

      "Payload type" ->
        ~w[comment text other anonymised]

      "Persistence mechanism" ->
        ~w[first-name middle-name last-name date-of-birth place-of-birth
          gender passport-number passport-country passport-expiration
          redress-number nationality visa-number issue-date-of-the-visa
          primary-residence country-of-residence special-service-request
          frequent-flyer-number travel-details payment-details place-
          port-of-original-embarkation place-port-of-clearance place-port-
          of-onward-foreign-destination passenger-name-record-locator-
            number comment text other phone-number identity-card-number
            anonymised]

        "Social network" ->
          ~w[github-username github-repository github-organisation jabber-
            id twitter-id email-src email-dst comment text other whois-
            registrant-email anonymised]

        "Support Tool" ->
          ~w[link text attachment comment other hex anonymised]

        "Targeting data" ->
          ~w[target-user target-email target-machine target-org target-location
            target-external comment anonymised]
      end
  end
end
