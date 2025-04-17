variable "vm_count" {
  description = "Количество одинаковых ВМ"
  type        = number
  default     = 3
}

variable "vm_template_id" {
  description = "ID образа ОС"
  type        = string
  default     = "fd81u2jojucn3njlptqo" # Debian-12
}

variable "vm_ssh_key" {
  description = "Публичный SSH-ключ"
  type        = string
}

variable "vm_resources" {
  description = "Ресурсы ВМ (CPU, RAM, Disk)"
  type = object({
    cpu  = number
    ram  = number
    disk = number
  })
  default = {
    cpu  = 2
    ram  = 2
    disk = 20
  }
}
