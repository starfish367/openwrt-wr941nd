# OpenWrt 18.06 Custom Kernel & Firmware for TP-Link TL-WR941ND v5

Bản firmware OpenWrt 18.06 (Linux Kernel 4.9) được tinh chỉnh sâu cấp mã nguồn (Kernel C Tuning & Driver C Patches) dành riêng cho router TP-Link TL-WR941ND v5 (Atheros AR9341, 4MB Flash / 32MB RAM).

## 1. Tinh chỉnh nhân Kernel & Mã nguồn (C-Level Tuning):
- **Tối ưu CPU MIPS 74Kc (`CPU_TYPE:=74kc`):** Ép trình biên dịch tối ưu hóa pipeline và tập lệnh của nhân MIPS 74Kc trên chip Atheros AR9341 thay vì nhân 24Kc thông dụng.
- **Kernel Slimming (Tiết kiệm Flash & RAM):** Tắt bỏ `CONFIG_KALLSYMS`, `CONFIG_DEBUG_FS`, `CONFIG_BUG`, giảm `LOG_BUF_SHIFT` xuống 8KB. Giúp kích thước nhân nén giảm từ 1.1MB xuống ~800KB.
- **ath9k Regulatory Unlock:** Gỡ bỏ hạn chế mã quốc gia cứng trong `regd.c`, cho phép hoạt động ổn định ở công suất tối ưu 19 dBm trên toàn dải tần.
- **Chống nghẽn độ trễ FQ-CoDel:** Hàng đợi FQ-CoDel tích hợp mặc định trên mọi cổng mạng.

## 2. Giao diện Web & Tối ưu hóa:
- Tích hợp giao diện quản trị Web LuCI (`http://182.68.0.1`, mật khẩu: `1234`).
- Loại bỏ triệt để gói rác: không PPP, không IPv6, không driver USB.
- Nhúng sẵn luật tường lửa chống treo video YouTube (chặn UDP 443 QUIC).
- Tích hợp script watchdog tự động phục hồi sóng WiFi 24/7.

## 3. Cách flash vào router:
```bash
scp openwrt-18.06.9-ar71xx-tiny-tl-wr941nd-v5-squashfs-sysupgrade.bin root@182.68.0.1:/tmp/firmware.bin
ssh root@182.68.0.1 "sysupgrade -v -n /tmp/firmware.bin"
```
