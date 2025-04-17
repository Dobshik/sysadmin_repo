resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_compute_disk" "boot_disk" {
  count    = var.vm_count
  name     = "debian-12-${count.index + 1}"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = var.vm_resources.disk
  image_id = var.vm_template_id
}

resource "yandex_compute_instance" "virtual_machine" {
  count = var.vm_count

  name = "debian-vm-${count.index + 1}"

  resources {
    cores  = var.vm_resources.cpu
    memory = var.vm_resources.ram
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot_disk[count.index].id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = <<EOF
#cloud-config
users:
  - name: s21309416
    groups: sudo
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh-authorized-keys:
      - ${var.vm_ssh_key}
disable_root: true
ssh_pwauth: false
EOF
  }
}
