{{- /*
Defines basics of custom policy
context:
    .context - root context
    .name - camelCase name of the policy
    .kind - kind of the policy (ClusterPolicy or Policy)
*/}}
{{- define "helpers.customPolicy" }}
{{- if and (ne .kind "ClusterPolicy") (ne .kind "Policy") }}
{{- fail "kind must be either ClusterPolicy or Policy" }}
{{- end }}
{{- $apiVersions := printf "kyverno.io/v1/%s" .kind }}
{{- $hasCapability := .context.Capabilities.APIVersions.Has $apiVersions }}
{{- $customPoliciesEnabled := dig "global" "customPolicies" "enabled" false .context.Values.AsMap }}
{{- $isEnabled := dig "global" "customPolicies" .name "enabled" $customPoliciesEnabled .context.Values.AsMap }}
{{- $kebabName := kebabcase .name }}
{{- toYaml (dict
    "name" $kebabName
    "enabled" (and $hasCapability $customPoliciesEnabled $isEnabled)
    "kind" .kind
)}}
{{- end }}