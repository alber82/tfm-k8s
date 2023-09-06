{{/*
Expand the name of the chart.
*/}}
{{- define "scheduler-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "scheduler-operator.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "scheduler-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "scheduler-operator.labels" -}}
helm.sh/chart: {{ include "scheduler-operator.chart" . }}
{{ include "scheduler-operator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "scheduler-operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "scheduler-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "scheduler-operator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "scheduler-operator.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the namespaces to watch (empty if the operator should watch the entire cluster).
If .Values.watchNamespaces = true, then use the release namespace.
If .Values.watchNamespaces is a string, use it.
If .Values.watchNamespaces is empty or false, return empty.
*/}}
{{- define "scheduler-operator.watchNamespaces" -}}
{{- if .Values.watchNamespaces -}}
{{- if kindIs "bool" .Values.watchNamespaces -}}
{{ .Release.Namespace }}
{{- else -}}
{{ .Values.watchNamespaces }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Determine whether to use ClusterRoles or Roles
*/}}
{{- define "scheduler-operator.roleType" -}}
{{- if .Values.watchNamespaces -}}
    Role
{{- else -}}
    ClusterRole
{{- end -}}
{{- end -}}