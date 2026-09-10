{{/*
Ten ngan cua chart, uu tien nameOverride neu nguoi dung co khai trong values.
*/}}
{{- define "demo-api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Ten day du dat cho moi object: "<release>-<chart>" (hoac fullnameOverride neu co khai).
Neu ten release da chua san ten chart thi khong lap lai, tranh ten qua dai (gioi han 63 ky tu).
*/}}
{{- define "demo-api.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Chuoi "<ten chart>-<version chart>", dung cho label helm.sh/chart.
*/}}
{{- define "demo-api.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Bo label chuan, gan vao metadata.labels cua moi object.
*/}}
{{- define "demo-api.labels" -}}
helm.sh/chart: {{ include "demo-api.chart" . }}
{{ include "demo-api.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Label dung de Service/Deployment nhan dung Pod cua nhau.
CHI dung 2 label nay lam selector - khong duoc doi qua cac ban release,
vi selector cua Deployment la immutable (doi se lam upgrade that bai).
*/}}
{{- define "demo-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "demo-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Ten ServiceAccount se dung: lay tu values.serviceAccount.name neu co khai,
khong thi dung fullname cua release lam ten mac dinh.
*/}}
{{- define "demo-api.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "demo-api.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}
