import serial
import time
import threading
import struct
import sys

class BramTestController:
    def __init__(self, port='COM3', baudrate=115200):  # Windows: COM3, Linux: /dev/ttyUSB0
        self.port = port
        self.baudrate = baudrate
        self.ser = None
        self.running = False
        self.interrupt_detected = False
        
    def connect(self):
        """UART 연결"""
        try:
            self.ser = serial.Serial(self.port, self.baudrate, timeout=1)
            print(f"Connected to {self.port} at {self.baudrate} baud")
            return True
        except serial.SerialException as e:
            print(f"Failed to connect: {e}")
            return False
    
    def disconnect(self):
        """UART 연결 해제"""
        if self.ser and self.ser.is_open:
            self.ser.close()
            print("Disconnected")
    
    def send_4byte_packet(self, byte1, byte2, byte3, byte4):
        """4바이트 패킷 전송 (big-endian)"""
        if self.ser and self.ser.is_open:
            packet = struct.pack('>BBBB', byte1, byte2, byte3, byte4)
            self.ser.write(packet)
            word_value = (byte1 << 24) | (byte2 << 16) | (byte3 << 8) | byte4
            print(f"Sent 4-byte packet: [0x{byte1:02X}, 0x{byte2:02X}, 0x{byte3:02X}, 0x{byte4:02X}] = 0x{word_value:08X}")
            return True
        return False
    
    def send_word(self, word_value):
        """32비트 워드를 4바이트로 분할하여 전송"""
        byte1 = (word_value >> 24) & 0xFF
        byte2 = (word_value >> 16) & 0xFF
        byte3 = (word_value >> 8) & 0xFF
        byte4 = word_value & 0xFF
        return self.send_4byte_packet(byte1, byte2, byte3, byte4)
    
    def receive_response(self):
        """응답 수신 (별도 스레드에서 실행)"""
        while self.running:
            if self.ser and self.ser.is_open:
                try:
                    if self.ser.in_waiting > 0:
                        response = self.ser.readline().decode('utf-8').strip()
                        if response:
                            print(f"📨 Received: {response}")
                            
                            # 패턴 감지 응답 확인
                            if "PATTERN_DETECTED" in response:
                                self.interrupt_detected = True
                                print("🎯 *** INTERRUPT DETECTED! Target pattern found! ***")
                            elif "SYSTEM_READY" in response:
                                print("✅ System is ready to receive 4-byte packets")
                            elif "WROTE_" in response:
                                print(f"📝 Write confirmed: {response}")
                                
                except Exception as e:
                    print(f"Receive error: {e}")
            time.sleep(0.01)  # 10ms 간격으로 체크
    
    def start_monitoring(self):
        """수신 모니터링 시작"""
        self.running = True
        self.receive_thread = threading.Thread(target=self.receive_response)
        self.receive_thread.daemon = True
        self.receive_thread.start()
    
    def stop_monitoring(self):
        """수신 모니터링 중지"""
        self.running = False
        if hasattr(self, 'receive_thread'):
            self.receive_thread.join()
    
    def sequential_word_test(self):
        """순차적으로 32비트 워드를 전송하는 테스트"""

        example_values = [0x12345678, 0x9ABCDEF0, 0x00000000, 0xFFFFFFAF, 0xFFFFFFFF, 0xAAAAAAAA]
        
        self.interrupt_detected = False
        
        for word in example_values:
            
            # 타겟 패턴인지 확인
            if word == 0xFFFFFFFF:
                print(f"🔥 Sending TARGET PATTERN: 0x{word:08X}")
            
            self.send_word(word)
            time.sleep(0.2)  # 200ms 간격
            
            # Interrupt가 감지되면 잠시 대기
            if self.interrupt_detected:
                print("⏸️  Pausing after interrupt detection...")
                time.sleep(2)
                self.interrupt_detected = False
        
        print("Sequential word test completed")
    
    def target_pattern_test(self):
        """타겟 패턴 0xFFFFFFFF 전송"""
        print("\n=== Target Pattern Test: Sending 0xFFFFFFFF ===")
        
        self.interrupt_detected = False
        
        print("🔥 Sending TARGET PATTERN: 0xFFFFFFFF")
        self.send_word(0xFFFFFFFF)
        
        # 응답 대기
        timeout = 5  # 5초 대기
        start_time = time.time()
        
        while not self.interrupt_detected and (time.time() - start_time) < timeout:
            time.sleep(0.1)
        
        if self.interrupt_detected:
            print("✅ Target pattern test successful!")
        else:
            print("⚠️  No interrupt detected within timeout. Check system configuration.")
    
    def custom_pattern_test(self):
        """사용자 정의 패턴들을 전송"""
        print("\n=== Custom Pattern Test ===")
        
        patterns = [
            0x00000000,  # All zeros
            0x12345678,  # Test pattern 1
            0xABCDEF00,  # Test pattern 2
            0xDEADBEEF,  # Classic test pattern
            0xFFFFFFFF,  # Target pattern
            0x55555555,  # Alternating pattern
            0xAAAAAAAA,  # Inverse alternating
        ]
        
        self.interrupt_detected = False
        
        for i, pattern in enumerate(patterns):
            print(f"\nSending pattern {i+1}/{len(patterns)}: 0x{pattern:08X}")
            
            if pattern == 0xFFFFFFFF:
                print("🔥 This is the TARGET PATTERN!")
                
            self.send_word(pattern)
            time.sleep(0.3)
            
            if self.interrupt_detected:
                print(f"🎯 Interrupt detected for pattern 0x{pattern:08X}!")
                time.sleep(1)
                self.interrupt_detected = False
        
        print("Custom pattern test completed")
    
    def rgb_simulation_test(self):
        """RGB 이미지 데이터 시뮬레이션 (RGB + Alpha)"""
        print("\n=== RGB Simulation Test ===")
        
        # 가상의 RGB 픽셀 데이터 생성
        pixels = [
            (0x12, 0x34, 0x56),  # RGB 1
            (0x78, 0x9A, 0xBC),  # RGB 2
            (0xDE, 0xF0, 0x12),  # RGB 3
            (0xFF, 0xFF, 0xFF),  # RGB 4 - 이것이 타겟 패턴을 만들 것
            (0x34, 0x56, 0x78),  # RGB 5
        ]
        
        self.interrupt_detected = False
        
        for i, (r, g, b) in enumerate(pixels):
            alpha = 0x00  # Alpha channel
            
            print(f"\nSending pixel {i+1}: R=0x{r:02X}, G=0x{g:02X}, B=0x{b:02X}, A=0x{alpha:02X}")
            
            # big-endian으로 패킹: RGBA
            self.send_4byte_packet(r, g, b, alpha)
            
            word_value = (r << 24) | (g << 16) | (b << 8) | alpha
            if word_value == 0xFFFFFF00:  # RGB가 모두 0xFF일 때
                print("🔥 This pixel has RGB = (0xFF, 0xFF, 0xFF)!")
            elif word_value == 0xFFFFFFFF:  # RGBA가 모두 0xFF일 때 (타겟 패턴)
                print("🔥 This is the TARGET PATTERN!")
            
            time.sleep(0.3)
            
            if self.interrupt_detected:
                print(f"🎯 Interrupt detected for pixel {i+1}!")
                time.sleep(1)
                self.interrupt_detected = False
        
        print("RGB simulation test completed")
    
    def interactive_mode(self):
        """대화형 모드"""
        print("\n=== Interactive Mode ===")
        print("Commands:")
        print("  word <hex_value>     - Send 32-bit word (e.g., 'word FFFFFFFF')")
        print("  bytes <b1> <b2> <b3> <b4> - Send 4 bytes (e.g., 'bytes FF FF FF FF')")
        print("  rgb <r> <g> <b>      - Send RGB with alpha=0 (e.g., 'rgb FF FF FF')")
        print("  seq <start> <count>  - Sequential word test (e.g., 'seq 12345678 10')")
        print("  target               - Send target pattern (0xFFFFFFFF)")
        print("  custom               - Send custom patterns")
        print("  rgbtest              - RGB simulation test")
        print("  quit                 - Exit")
        
        while True:
            try:
                cmd = input("\n> ").strip().lower()
                
                if cmd == 'quit':
                    break
                elif cmd == 'target':
                    self.target_pattern_test()
                elif cmd == 'custom':
                    self.custom_pattern_test()
                elif cmd == 'rgbtest':
                    self.rgb_simulation_test()
                elif cmd.startswith('word '):
                    try:
                        hex_str = cmd.split()[1]
                        value = int(hex_str, 16)
                        self.send_word(value)
                    except (ValueError, IndexError):
                        print("Invalid format. Use: word FFFFFFFF")
                elif cmd.startswith('bytes '):
                    try:
                        parts = cmd.split()[1:5]
                        if len(parts) != 4:
                            raise ValueError
                        bytes_list = [int(b, 16) for b in parts]
                        self.send_4byte_packet(*bytes_list)
                    except (ValueError, IndexError):
                        print("Invalid format. Use: bytes FF FF FF FF")
                elif cmd.startswith('rgb '):
                    try:
                        parts = cmd.split()[1:4]
                        if len(parts) != 3:
                            raise ValueError
                        r, g, b = [int(c, 16) for c in parts]
                        self.send_4byte_packet(r, g, b, 0x00)  # Alpha = 0
                    except (ValueError, IndexError):
                        print("Invalid format. Use: rgb FF FF FF")
                elif cmd.startswith('seq '):
                    try:
                        parts = cmd.split()
                        self.sequential_word_test()
                    except (ValueError, IndexError):
                        print("Invalid format. Use: seq 12345678 10")
                else:
                    print("Unknown command")
                    
            except KeyboardInterrupt:
                break

def main():
    # UART 포트 설정 (시스템에 맞게 변경)
    port = 'COM3'  # 여기를 실제 포트로 변경하세요
    
    controller = BramTestController(port=port, baudrate=115200)
    
    if not controller.connect():
        print("Failed to connect to UART. Check port and cable.")
        return
    
    # 수신 모니터링 시작
    controller.start_monitoring()
    
    try:
        print("Waiting for system ready...")
        time.sleep(2)  # 시스템 초기화 대기
        
        # 자동 테스트 실행
        print("\n" + "="*60)
        print("Starting automatic tests...")
        
        # 1. 순차 워드 테스트
        controller.sequential_word_test()
        time.sleep(1)
        
        # 2. 타겟 패턴 테스트
        #controller.target_pattern_test()
        #time.sleep(1)
        
        # 3. RGB 시뮬레이션 테스트
        #controller.rgb_simulation_test()
        #time.sleep(1)
        
        # 4. 대화형 모드
        controller.interactive_mode()
        
    except KeyboardInterrupt:
        print("\nStopping...")
    finally:
        controller.stop_monitoring()
        controller.disconnect()

if __name__ == "__main__":
    print("BRAM Write Monitor Test Controller (4-byte packet mode)")
    print("Make sure your FPGA board is connected and programmed")
    print("Update the COM port in the code if needed")
    print("-" * 60)
    main()
