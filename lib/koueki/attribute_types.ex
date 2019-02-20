defmodule Koueki.Attribute.Type do
  @doc """
  Retrieve all types valid within MISP

  This is absolutely disgusting but a single source of truth for types
  (which is more than MISP can do hehe)

  To future me: 
    If you ever need to regenerate these, use the following JS

      let out = {};
      let resp = await fetch("http://localhost/attributes/describeTypes.json");
      let json = await resp.json();
      json.forEach(type => {
        out[type] = ({
          valid_for: Object.keys(temp2.result.category_type_mappings)
                           .filter(key => 
                              temp2.result.category_type_mappings[key].includes(type)
                           ),
          defaults: {
            category: temp2.result.sane_defaults[type].default_category,
            to_ids: Boolean(temp2.result.sane_defaults[type].to_ids)
          }
        }));

        JSON.stringify(out).replace(/{/g, "%{").replace(/:/g, ": ");
  """
  def types do
    %{
      md5: %{
        valid_for: [
          "Payload delivery",
          "Artifacts dropped",
          "Payload installation",
          "External analysis"
        ],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      sha1: %{
        valid_for: [
          "Payload delivery",
          "Artifacts dropped",
          "Payload installation",
          "External analysis"
        ],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      sha256: %{
        valid_for: [
          "Payload delivery",
          "Artifacts dropped",
          "Payload installation",
          "External analysis"
        ],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      filename: %{
        valid_for: [
          "Payload delivery",
          "Artifacts dropped",
          "Payload installation",
          "Persistence mechanism",
          "External analysis"
        ],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      pdb: %{
        valid_for: ["Artifacts dropped"],
        defaults: %{category: "Artifacts dropped", to_ids: false}
      },
      "filename|md5": %{
        valid_for: [
          "Payload delivery",
          "Artifacts dropped",
          "Payload installation",
          "External analysis"
        ],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      "filename|sha1": %{
        valid_for: [
          "Payload delivery",
          "Artifacts dropped",
          "Payload installation",
          "External analysis"
        ],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      "filename|sha256": %{
        valid_for: [
          "Payload delivery",
          "Artifacts dropped",
          "Payload installation",
          "External analysis"
        ],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      "ip-src": %{
        valid_for: ["Payload delivery", "Network activity", "External analysis"],
        defaults: %{category: "Network activity", to_ids: true}
      },
      "ip-dst": %{
        valid_for: ["Payload delivery", "Network activity", "External analysis"],
        defaults: %{category: "Network activity", to_ids: true}
      },
      hostname: %{
        valid_for: ["Payload delivery", "Network activity", "External analysis"],
        defaults: %{category: "Network activity", to_ids: true}
      },
      domain: %{
        valid_for: ["Payload delivery", "Network activity", "External analysis"],
        defaults: %{category: "Network activity", to_ids: true}
      },
      "domain|ip": %{
        valid_for: ["Network activity", "External analysis"],
        defaults: %{category: "Network activity", to_ids: true}
      },
      "email-src": %{
        valid_for: ["Payload delivery", "Social network"],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      "email-dst": %{
        valid_for: ["Payload delivery", "Network activity", "Social network"],
        defaults: %{category: "Network activity", to_ids: true}
      },
      "email-subject": %{
        valid_for: ["Payload delivery"],
        defaults: %{category: "Payload delivery", to_ids: false}
      },
      "email-attachment": %{
        valid_for: ["Payload delivery"],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      "email-body": %{
        valid_for: ["Payload delivery"],
        defaults: %{category: "Payload delivery", to_ids: false}
      },
      float: %{valid_for: ["Other"], defaults: %{category: "Other", to_ids: false}},
      url: %{
        valid_for: ["Payload delivery", "Network activity", "External analysis"],
        defaults: %{category: "Network activity", to_ids: true}
      },
      "http-method": %{
        valid_for: ["Network activity"],
        defaults: %{category: "Network activity", to_ids: false}
      },
      "user-agent": %{
        valid_for: ["Payload delivery", "Network activity", "External analysis"],
        defaults: %{category: "Network activity", to_ids: false}
      },
      "ja3-fingerprint-md5": %{
        valid_for: ["Payload delivery", "Network activity", "External analysis"],
        defaults: %{category: "Network activity", to_ids: true}
      },
      "hassh-md5": %{
        valid_for: ["Payload delivery", "Network activity", "External analysis"],
        defaults: %{category: "Network activity", to_ids: true}
      },
      "hasshserver-md5": %{
        valid_for: ["Payload delivery", "Network activity", "External analysis"],
        defaults: %{category: "Network activity", to_ids: true}
      },
      regkey: %{
        valid_for: ["Artifacts dropped", "Persistence mechanism", "External analysis"],
        defaults: %{category: "Persistence mechanism", to_ids: true}
      },
      "regkey|value": %{
        valid_for: ["Artifacts dropped", "Persistence mechanism", "External analysis"],
        defaults: %{category: "Persistence mechanism", to_ids: true}
      },
      AS: %{
        valid_for: ["Payload delivery", "Network activity", "External analysis"],
        defaults: %{category: "Network activity", to_ids: false}
      },
      snort: %{
        valid_for: ["Network activity", "External analysis"],
        defaults: %{category: "Network activity", to_ids: true}
      },
      bro: %{
        valid_for: ["Network activity", "External analysis"],
        defaults: %{category: "Network activity", to_ids: true}
      },
      zeek: %{
        valid_for: ["Network activity", "External analysis"],
        defaults: %{category: "Network activity", to_ids: true}
      },
      "pattern-in-file": %{
        valid_for: [
          "Payload delivery",
          "Artifacts dropped",
          "Payload installation",
          "Network activity",
          "External analysis"
        ],
        defaults: %{category: "Payload installation", to_ids: true}
      },
      "pattern-in-traffic": %{
        valid_for: [
          "Payload delivery",
          "Payload installation",
          "Network activity",
          "External analysis"
        ],
        defaults: %{category: "Network activity", to_ids: true}
      },
      "pattern-in-memory": %{
        valid_for: ["Artifacts dropped", "Payload installation", "External analysis"],
        defaults: %{category: "Payload installation", to_ids: true}
      },
      yara: %{
        valid_for: ["Payload delivery", "Artifacts dropped", "Payload installation"],
        defaults: %{category: "Payload installation", to_ids: true}
      },
      "stix2-pattern": %{
        valid_for: [
          "Payload delivery",
          "Artifacts dropped",
          "Payload installation",
          "Network activity"
        ],
        defaults: %{category: "Payload installation", to_ids: true}
      },
      sigma: %{
        valid_for: ["Payload delivery", "Artifacts dropped", "Payload installation"],
        defaults: %{category: "Payload installation", to_ids: true}
      },
      gene: %{
        valid_for: ["Artifacts dropped"],
        defaults: %{category: "Artifacts dropped", to_ids: false}
      },
      "mime-type": %{
        valid_for: ["Payload delivery", "Artifacts dropped", "Payload installation"],
        defaults: %{category: "Artifacts dropped", to_ids: false}
      },
      "identity-card-number": %{
        valid_for: ["Person"],
        defaults: %{category: "Person", to_ids: false}
      },
      cookie: %{
        valid_for: ["Artifacts dropped", "Network activity"],
        defaults: %{category: "Network activity", to_ids: false}
      },
      vulnerability: %{
        valid_for: ["Payload delivery", "Payload installation", "External analysis"],
        defaults: %{category: "External analysis", to_ids: false}
      },
      attachment: %{
        valid_for: [
          "Antivirus detection",
          "Payload delivery",
          "Artifacts dropped",
          "Payload installation",
          "Network activity",
          "External analysis",
          "Support Tool"
        ],
        defaults: %{category: "External analysis", to_ids: false}
      },
      "malware-sample": %{
        valid_for: [
          "Payload delivery",
          "Artifacts dropped",
          "Payload installation",
          "External analysis"
        ],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      link: %{
        valid_for: [
          "Internal reference",
          "Antivirus detection",
          "Payload delivery",
          "External analysis",
          "Support Tool"
        ],
        defaults: %{category: "External analysis", to_ids: false}
      },
      comment: %{
        valid_for: [
          "Internal reference",
          "Targeting data",
          "Antivirus detection",
          "Payload delivery",
          "Artifacts dropped",
          "Payload installation",
          "Persistence mechanism",
          "Network activity",
          "Payload type",
          "Attribution",
          "External analysis",
          "Financial fraud",
          "Support Tool",
          "Social network",
          "Person",
          "Other"
        ],
        defaults: %{category: "Other", to_ids: false}
      },
      text: %{
        valid_for: [
          "Internal reference",
          "Antivirus detection",
          "Payload delivery",
          "Artifacts dropped",
          "Payload installation",
          "Persistence mechanism",
          "Network activity",
          "Payload type",
          "Attribution",
          "External analysis",
          "Financial fraud",
          "Support Tool",
          "Social network",
          "Person",
          "Other"
        ],
        defaults: %{category: "Other", to_ids: false}
      },
      hex: %{
        valid_for: [
          "Internal reference",
          "Antivirus detection",
          "Payload delivery",
          "Artifacts dropped",
          "Payload installation",
          "Persistence mechanism",
          "Network activity",
          "Financial fraud",
          "Support Tool",
          "Other"
        ],
        defaults: %{category: "Other", to_ids: false}
      },
      other: %{
        valid_for: [
          "Internal reference",
          "Antivirus detection",
          "Payload delivery",
          "Artifacts dropped",
          "Payload installation",
          "Persistence mechanism",
          "Network activity",
          "Payload type",
          "Attribution",
          "External analysis",
          "Financial fraud",
          "Support Tool",
          "Social network",
          "Person",
          "Other"
        ],
        defaults: %{category: "Other", to_ids: false}
      },
      "named pipe": %{
        valid_for: ["Artifacts dropped"],
        defaults: %{category: "Artifacts dropped", to_ids: false}
      },
      mutex: %{
        valid_for: ["Artifacts dropped"],
        defaults: %{category: "Artifacts dropped", to_ids: true}
      },
      "target-user": %{
        valid_for: ["Targeting data"],
        defaults: %{category: "Targeting data", to_ids: false}
      },
      "target-email": %{
        valid_for: ["Targeting data"],
        defaults: %{category: "Targeting data", to_ids: false}
      },
      "target-machine": %{
        valid_for: ["Targeting data"],
        defaults: %{category: "Targeting data", to_ids: false}
      },
      "target-org": %{
        valid_for: ["Targeting data"],
        defaults: %{category: "Targeting data", to_ids: false}
      },
      "target-location": %{
        valid_for: ["Targeting data"],
        defaults: %{category: "Targeting data", to_ids: false}
      },
      "target-external": %{
        valid_for: ["Targeting data"],
        defaults: %{category: "Targeting data", to_ids: false}
      },
      btc: %{
        valid_for: ["Financial fraud"],
        defaults: %{category: "Financial fraud", to_ids: true}
      },
      xmr: %{
        valid_for: ["Financial fraud"],
        defaults: %{category: "Financial fraud", to_ids: true}
      },
      iban: %{
        valid_for: ["Financial fraud"],
        defaults: %{category: "Financial fraud", to_ids: true}
      },
      bic: %{
        valid_for: ["Financial fraud"],
        defaults: %{category: "Financial fraud", to_ids: true}
      },
      "bank-account-nr": %{
        valid_for: ["Financial fraud"],
        defaults: %{category: "Financial fraud", to_ids: true}
      },
      "aba-rtn": %{
        valid_for: ["Financial fraud"],
        defaults: %{category: "Financial fraud", to_ids: true}
      },
      bin: %{
        valid_for: ["Financial fraud"],
        defaults: %{category: "Financial fraud", to_ids: true}
      },
      "cc-number": %{
        valid_for: ["Financial fraud"],
        defaults: %{category: "Financial fraud", to_ids: true}
      },
      prtn: %{
        valid_for: ["Financial fraud"],
        defaults: %{category: "Financial fraud", to_ids: true}
      },
      "phone-number": %{
        valid_for: ["Financial fraud", "Person", "Other"],
        defaults: %{category: "Person", to_ids: false}
      },
      "threat-actor": %{
        valid_for: ["Attribution"],
        defaults: %{category: "Attribution", to_ids: false}
      },
      "campaign-name": %{
        valid_for: ["Attribution"],
        defaults: %{category: "Attribution", to_ids: false}
      },
      "campaign-id": %{
        valid_for: ["Attribution"],
        defaults: %{category: "Attribution", to_ids: false}
      },
      "malware-type": %{
        valid_for: ["Payload delivery", "Payload installation"],
        defaults: %{category: "Payload delivery", to_ids: false}
      },
      uri: %{
        valid_for: ["Network activity"],
        defaults: %{category: "Network activity", to_ids: true}
      },
      authentihash: %{
        valid_for: ["Payload delivery", "Artifacts dropped", "Payload installation"],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      ssdeep: %{
        valid_for: ["Payload delivery", "Artifacts dropped", "Payload installation"],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      imphash: %{
        valid_for: ["Payload delivery", "Artifacts dropped", "Payload installation"],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      pehash: %{
        valid_for: ["Payload delivery", "Payload installation"],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      impfuzzy: %{
        valid_for: ["Payload delivery", "Artifacts dropped", "Payload installation"],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      sha224: %{
        valid_for: ["Payload delivery", "Artifacts dropped", "Payload installation"],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      sha384: %{
        valid_for: ["Payload delivery", "Artifacts dropped", "Payload installation"],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      sha512: %{
        valid_for: ["Payload delivery", "Artifacts dropped", "Payload installation"],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      "sha512/224": %{
        valid_for: ["Payload delivery", "Artifacts dropped", "Payload installation"],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      "sha512/256": %{
        valid_for: ["Payload delivery", "Artifacts dropped", "Payload installation"],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      tlsh: %{
        valid_for: ["Payload delivery", "Payload installation"],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      cdhash: %{
        valid_for: ["Payload delivery", "Artifacts dropped", "Payload installation"],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      "filename|authentihash": %{
        valid_for: ["Payload delivery", "Artifacts dropped", "Payload installation"],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      "filename|ssdeep": %{
        valid_for: ["Payload delivery", "Artifacts dropped", "Payload installation"],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      "filename|imphash": %{
        valid_for: ["Payload delivery", "Artifacts dropped", "Payload installation"],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      "filename|impfuzzy": %{
        valid_for: ["Payload delivery", "Artifacts dropped", "Payload installation"],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      "filename|pehash": %{
        valid_for: ["Payload delivery", "Artifacts dropped", "Payload installation"],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      "filename|sha224": %{
        valid_for: ["Payload delivery", "Artifacts dropped", "Payload installation"],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      "filename|sha384": %{
        valid_for: ["Payload delivery", "Artifacts dropped", "Payload installation"],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      "filename|sha512": %{
        valid_for: ["Payload delivery", "Artifacts dropped", "Payload installation"],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      "filename|sha512/224": %{
        valid_for: ["Payload delivery", "Artifacts dropped", "Payload installation"],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      "filename|sha512/256": %{
        valid_for: ["Payload delivery", "Artifacts dropped", "Payload installation"],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      "filename|tlsh": %{
        valid_for: ["Payload delivery", "Artifacts dropped", "Payload installation"],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      "windows-scheduled-task": %{
        valid_for: ["Artifacts dropped"],
        defaults: %{category: "Artifacts dropped", to_ids: false}
      },
      "windows-service-name": %{
        valid_for: ["Artifacts dropped"],
        defaults: %{category: "Artifacts dropped", to_ids: false}
      },
      "windows-service-displayname": %{
        valid_for: ["Artifacts dropped"],
        defaults: %{category: "Artifacts dropped", to_ids: false}
      },
      "whois-registrant-email": %{
        valid_for: ["Payload delivery", "Attribution", "Social network"],
        defaults: %{category: "Attribution", to_ids: false}
      },
      "whois-registrant-phone": %{
        valid_for: ["Attribution"],
        defaults: %{category: "Attribution", to_ids: false}
      },
      "whois-registrant-name": %{
        valid_for: ["Attribution"],
        defaults: %{category: "Attribution", to_ids: false}
      },
      "whois-registrant-org": %{
        valid_for: ["Attribution"],
        defaults: %{category: "Attribution", to_ids: false}
      },
      "whois-registrar": %{
        valid_for: ["Attribution"],
        defaults: %{category: "Attribution", to_ids: false}
      },
      "whois-creation-date": %{
        valid_for: ["Attribution"],
        defaults: %{category: "Attribution", to_ids: false}
      },
      "x509-fingerprint-sha1": %{
        valid_for: [
          "Payload delivery",
          "Artifacts dropped",
          "Payload installation",
          "Network activity",
          "Attribution",
          "External analysis"
        ],
        defaults: %{category: "Network activity", to_ids: true}
      },
      "x509-fingerprint-md5": %{
        valid_for: [
          "Payload delivery",
          "Artifacts dropped",
          "Payload installation",
          "Network activity",
          "Attribution",
          "External analysis"
        ],
        defaults: %{category: "Network activity", to_ids: true}
      },
      "x509-fingerprint-sha256": %{
        valid_for: [
          "Payload delivery",
          "Artifacts dropped",
          "Payload installation",
          "Network activity",
          "Attribution",
          "External analysis"
        ],
        defaults: %{category: "Network activity", to_ids: true}
      },
      "dns-soa-email": %{
        valid_for: ["Attribution"],
        defaults: %{category: "Attribution", to_ids: false}
      },
      "size-in-bytes": %{valid_for: ["Other"], defaults: %{category: "Other", to_ids: false}},
      counter: %{valid_for: ["Other"], defaults: %{category: "Other", to_ids: false}},
      datetime: %{valid_for: ["Other"], defaults: %{category: "Other", to_ids: false}},
      cpe: %{valid_for: ["Other"], defaults: %{category: "Other", to_ids: false}},
      port: %{
        valid_for: ["Network activity", "Other"],
        defaults: %{category: "Network activity", to_ids: false}
      },
      "ip-dst|port": %{
        valid_for: ["Payload delivery", "Network activity", "External analysis"],
        defaults: %{category: "Network activity", to_ids: true}
      },
      "ip-src|port": %{
        valid_for: ["Payload delivery", "Network activity", "External analysis"],
        defaults: %{category: "Network activity", to_ids: true}
      },
      "hostname|port": %{
        valid_for: ["Payload delivery", "Network activity"],
        defaults: %{category: "Network activity", to_ids: true}
      },
      "mac-address": %{
        valid_for: ["Payload delivery", "Network activity", "External analysis"],
        defaults: %{category: "Network activity", to_ids: false}
      },
      "mac-eui-64": %{
        valid_for: ["Payload delivery", "Network activity", "External analysis"],
        defaults: %{category: "Network activity", to_ids: false}
      },
      "email-dst-display-name": %{
        valid_for: ["Payload delivery"],
        defaults: %{category: "Payload delivery", to_ids: false}
      },
      "email-src-display-name": %{
        valid_for: ["Payload delivery"],
        defaults: %{category: "Payload delivery", to_ids: false}
      },
      "email-header": %{
        valid_for: ["Payload delivery"],
        defaults: %{category: "Payload delivery", to_ids: false}
      },
      "email-reply-to": %{
        valid_for: ["Payload delivery"],
        defaults: %{category: "Payload delivery", to_ids: false}
      },
      "email-x-mailer": %{
        valid_for: ["Payload delivery"],
        defaults: %{category: "Payload delivery", to_ids: false}
      },
      "email-mime-boundary": %{
        valid_for: ["Payload delivery"],
        defaults: %{category: "Payload delivery", to_ids: false}
      },
      "email-thread-index": %{
        valid_for: ["Payload delivery"],
        defaults: %{category: "Payload delivery", to_ids: false}
      },
      "email-message-id": %{
        valid_for: ["Payload delivery"],
        defaults: %{category: "Payload delivery", to_ids: false}
      },
      "github-username": %{
        valid_for: ["Social network"],
        defaults: %{category: "Social network", to_ids: false}
      },
      "github-repository": %{
        valid_for: ["External analysis", "Social network"],
        defaults: %{category: "Social network", to_ids: false}
      },
      "github-organisation": %{
        valid_for: ["Social network"],
        defaults: %{category: "Social network", to_ids: false}
      },
      "jabber-id": %{
        valid_for: ["Social network"],
        defaults: %{category: "Social network", to_ids: false}
      },
      "twitter-id": %{
        valid_for: ["Social network"],
        defaults: %{category: "Social network", to_ids: false}
      },
      "first-name": %{valid_for: ["Person"], defaults: %{category: "Person", to_ids: false}},
      "middle-name": %{valid_for: ["Person"], defaults: %{category: "Person", to_ids: false}},
      "last-name": %{valid_for: ["Person"], defaults: %{category: "Person", to_ids: false}},
      "date-of-birth": %{valid_for: ["Person"], defaults: %{category: "Person", to_ids: false}},
      "place-of-birth": %{valid_for: ["Person"], defaults: %{category: "Person", to_ids: false}},
      gender: %{valid_for: ["Person"], defaults: %{category: "Person", to_ids: false}},
      "passport-number": %{valid_for: ["Person"], defaults: %{category: "Person", to_ids: false}},
      "passport-country": %{valid_for: ["Person"], defaults: %{category: "Person", to_ids: false}},
      "passport-expiration": %{
        valid_for: ["Person"],
        defaults: %{category: "Person", to_ids: false}
      },
      "redress-number": %{valid_for: ["Person"], defaults: %{category: "Person", to_ids: false}},
      nationality: %{valid_for: ["Person"], defaults: %{category: "Person", to_ids: false}},
      "visa-number": %{valid_for: ["Person"], defaults: %{category: "Person", to_ids: false}},
      "issue-date-of-the-visa": %{
        valid_for: ["Person"],
        defaults: %{category: "Person", to_ids: false}
      },
      "primary-residence": %{
        valid_for: ["Person"],
        defaults: %{category: "Person", to_ids: false}
      },
      "country-of-residence": %{
        valid_for: ["Person"],
        defaults: %{category: "Person", to_ids: false}
      },
      "special-service-request": %{
        valid_for: ["Person"],
        defaults: %{category: "Person", to_ids: false}
      },
      "frequent-flyer-number": %{
        valid_for: ["Person"],
        defaults: %{category: "Person", to_ids: false}
      },
      "travel-details": %{valid_for: ["Person"], defaults: %{category: "Person", to_ids: false}},
      "payment-details": %{valid_for: ["Person"], defaults: %{category: "Person", to_ids: false}},
      "place-port-of-original-embarkation": %{
        valid_for: ["Person"],
        defaults: %{category: "Person", to_ids: false}
      },
      "place-port-of-clearance": %{
        valid_for: ["Person"],
        defaults: %{category: "Person", to_ids: false}
      },
      "place-port-of-onward-foreign-destination": %{
        valid_for: ["Person"],
        defaults: %{category: "Person", to_ids: false}
      },
      "passenger-name-record-locator-number": %{
        valid_for: ["Person"],
        defaults: %{category: "Person", to_ids: false}
      },
      "mobile-application-id": %{
        valid_for: ["Payload delivery", "Payload installation"],
        defaults: %{category: "Payload delivery", to_ids: true}
      },
      cortex: %{
        valid_for: ["External analysis"],
        defaults: %{category: "External analysis", to_ids: false}
      },
      boolean: %{valid_for: ["Other"], defaults: %{category: "Other", to_ids: false}},
      anonymised: %{
        valid_for: [
          "Internal reference",
          "Targeting data",
          "Antivirus detection",
          "Payload delivery",
          "Artifacts dropped",
          "Payload installation",
          "Persistence mechanism",
          "Network activity",
          "Payload type",
          "Attribution",
          "External analysis",
          "Financial fraud",
          "Support Tool",
          "Social network",
          "Person",
          "Other"
        ],
        defaults: %{category: "Other", to_ids: false}
      }
    }
  end

  def get_all("string") do
    types()
    |> Map.keys()
    |> Enum.map(fn x -> to_string(x) end)
  end

  def get(type) when is_atom(type) do
    Map.get(types(), type)
  end

  def get(type) when is_binary(type) do
    Map.get(types(), String.to_atom(type))
  end

end
