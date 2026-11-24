# Quy Chuẩn Dự Án OpenWrt TL-WR941ND v5 (AR9341 - 4MB Flash / 32MB RAM)

## 1. Môi Trường Phần Cứng & Kiến Trúc
- **Thiết bị:** TP-Link TL-WR941ND v5 (Atheros AR9341 SoC, MIPS 74Kc, 4MB SPI Flash, 32MB DDR RAM).
- **Hệ điều hành:** OpenWrt 18.06 (Linux kernel 4.9, target `ar71xx/tiny`).
- **Hạn mức Flash & RAM:**
  - Kích thước phân vùng Firmware: Tối đa 3.932.160 bytes (~3.75 MB). Mọi firmware build ra phải nhỏ hơn kích thước này.
  - RAM tự do hạn hẹp: Cấm chạy các dịch vụ nặng ngốn RAM; mọi daemon phải tinh gọn (Dnsmasq 2.90, Dropbear 2020.81).

## 2. Tiêu Chuẩn Giám Sát Build GitHub Actions (Quy Chuẩn Điều 6)
- **Điều kiện kích hoạt:** CHỈ kích hoạt bộ hẹn giờ giám sát 50 phút KHI CÓ TIẾN TRÌNH BUILD ĐANG CHẠY (in_progress / queued). Khi tiến trình build đã hoàn tất (success / completed) hoặc trạng thái nghỉ (Idle), PHẢI NGAY LẬP TỨC HỦY BỘ HẸN GIỜ (`manage_task kill`), dừng hẳn việc báo cáo định kỳ, không để hẹn giờ chạy lặp vô nghĩa làm phiền người dùng.
- **Chu kỳ kiểm tra khi đang build:** Đúng **50 phút** / lần (sử dụng subagent `flash_lite` để tiết kiệm token).
- **Yêu cầu báo cáo mỗi lần kiểm tra (chỉ khi đang build):**
  - Khai báo rõ thời gian thực tế lúc đang kiểm tra (ví dụ: `14:30:00 (GMT+7)`).
  - Báo cáo rõ tình trạng sccache / output cache (dung lượng cache thực tế, cache được kích hoạt/lưu trữ).
  - Báo cáo rõ bước hiện tại của quá trình compile (đang ở giai đoạn nào, target compilation, linking, packaging, hay hoàn tất).

## 3. Tối Ưu Hóa Wi-Fi Di Động (Android & iOS)
- **Khử triệt để lỗi đá ngắt kết nối khi ngủ sâu (Doze Mode):**
  - Luôn đặt `option max_inactivity '86400'`, `option wpa_group_rekey '86400'` và `option disassoc_low_ack '0'` trong `/etc/config/wireless` cho giao diện phát sóng AP (`openwrt`).
  - Mặc định hostapd (300 giây) sẽ đá máy khi không hoạt động; tham số 86400 giúp duy trì kết nối bền vững 24/7.
- **Tối ưu chu kỳ đánh thức tiết kiệm pin:**
  - Luôn đặt `option dtim_period '2'` (200ms) và tắt U-APSD (`option uapsd '0'`) trên driver `ath9k` để chống desync khung truyền tiết kiệm pin của chip Wi-Fi di động.

## 4. Xử Lý IPv6 Blackhole & Dnsmasq
- Khi router hoạt động ở chế độ Repeater không có định tuyến IPv6 WAN ra Internet, BẮT BUỘC cấu hình cờ `filter-AAAA` trong `/etc/dnsmasq.conf`.
- Chặn đứng hoàn toàn hiện tượng điện thoại Android bị treo 5-10s trong quá trình Captive Portal Network Validation (`connectivitycheck.gstatic.com/generate_204`), chấm dứt lỗi tự ngắt Wi-Fi chuyển sang 4G.

## 5. Việt Hóa Giao Diện LuCI (100% Zero-Emoji & Nhúng Flash)
- Mọi bản dịch LuCI (`base.vi.lmo`, `firewall.vi.lmo`) phải dịch hoàn thiện 100% chuỗi (không để trống, không fuzzy).
- Tuân thủ nghiêm ngặt Quy tắc Zero-Emoji (Rule 7), bảo toàn biến format (`%s`, `%d`, thẻ HTML).
- Lưu trữ trực tiếp trong thư mục `files/usr/lib/lua/luci/i18n/` để tự động nhúng vào phân vùng nén SquashFS của ROM mới, bảo vệ bộ nhớ `/overlay` không bị tiêu hao.
