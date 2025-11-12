{{- define "demo-worker.name" -}}{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}{{- end -}}
{{- define "demo-worker.fullname" -}}{{- if .Values.fullnameOverride -}}{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}{{- else -}}{{- $name := default .Chart.Name .Values.nameOverride -}}{{- if contains $name .Release.Name -}}{{- .Release.Name | trunc 63 | trimSuffix "-" -}}{{- else -}}{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}{{- end -}}{{- end -}}{{- end -}}
{{- define "demo-worker.labels" -}}
app.kubernetes.io/name: {{ include "demo-worker.name" . }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
