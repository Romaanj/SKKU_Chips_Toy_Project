#include "xparameters.h"
#include "xintc.h"
#include "xuartlite.h"
#include "xuartlite_l.h"
#include "xil_exception.h"
#include "xil_printf.h"
#include "xstatus.h"
#include "sleep.h"
#include <string.h>

// 인스턴스 선언
XIntc InterruptController;
XUartLite UartLite;

// BRAM 기본 설정
#define BRAM_BASE_ADDR      0xC0000000
#define BRAM_START_OFFSET   0xCFF0     // 0xC000_CFF0부터 시작
#define BRAM_TARGET_OFFSET  0xD000     // 0xC000_D000이 타겟
#define TARGET_PATTERN      0xFFFFFFFF

volatile uint32_t* bram_ptr = (volatile uint32_t*)BRAM_BASE_ADDR;
volatile uint32_t current_offset = BRAM_START_OFFSET;
volatile uint8_t interrupt_occurred = 0;

// Interrupt Service Routine
void BramWriteInterruptHandler(void *CallbackRef) {
    // UART로 응답 메시지 전송
    char response[] = "PATTERN_DETECTED\n";
    XUartLite_Send(&UartLite, (uint8_t*)response, strlen(response));
    
    interrupt_occurred = 1;
    xil_printf("Interrupt: Pattern detected at address 0x%08X\n", 
               BRAM_BASE_ADDR + current_offset - 4);
}

// 4바이트 수신 후 BRAM에 쓰기
void ProcessFourBytes() {
    uint8_t buf[4];
    uint32_t word;
    uint32_t write_addr;
    
    // 4바이트 연속 수신 (big-endian)
    for (int i = 0; i < 4; i++) {
        while (XUartLite_IsReceiveEmpty(UART_BASEADDR));
        buf[i] = XUartLite_RecvByte(UART_BASEADDR);
    }
    
    // big-endian으로 수신된 데이터를 32비트 워드로 구성
    word = (buf[0] << 24) | (buf[1] << 16) | (buf[2] << 8) | buf[3];
    
    // BRAM에 쓰기
    write_addr = BRAM_BASE_ADDR + current_offset;
    bram_ptr[current_offset] = word;
    
    xil_printf("Written 0x%08X to address 0x%08X (offset: 0x%04X)\n", 
               word, write_addr, current_offset);
    xil_printf("Bytes: [0x%02X, 0x%02X, 0x%02X, 0x%02X]\n", 
               buf[0], buf[1], buf[2], buf[3]);
    
    // 다음 주소로 이동 (4바이트씩)
    current_offset += 4;
    
    // 범위를 벗어나면 다시 시작점으로
    if (current_offset > 0xD010) {
        current_offset = BRAM_START_OFFSET;
        xil_printf("Address wrapped around to start\n");
    }
    
    // UART로 현재 상태 전송
    char status_msg[64];
    sprintf(status_msg, "WROTE_0x%08X_TO_0x%04X\n", word, current_offset-4);
    XUartLite_Send(&UartLite, (u8*)status_msg, strlen(status_msg));
}

int main() {
    int Status;
    
    xil_printf("=== BRAM Write Monitor System ===\n");
    
    // UART 초기화
    Status = XUartLite_Initialize(&UartLite, XPAR_XUARTLITE_0_BASEADDR);
    if (Status != XST_SUCCESS) {
        xil_printf("UART initialization failed\n");
        return XST_FAILURE;
    }
    xil_printf("UART initialized\n");
    
    // Interrupt Controller 초기화
    Status = XIntc_Initialize(&InterruptController, XPAR_XINTC_0_BASEADDR);
    if (Status != XST_SUCCESS) {
        xil_printf("Interrupt Controller initialization failed\n");
        return XST_FAILURE;
    }
    xil_printf("Interrupt Controller initialized\n");
    
    // Interrupt Handler 연결 (interrupt ID는 0번 사용)
    Status = XIntc_Connect(&InterruptController, 0,
                          (XInterruptHandler)BramWriteInterruptHandler, 
                          NULL);
    if (Status != XST_SUCCESS) {
        xil_printf("Interrupt Handler connection failed\n");
        return XST_FAILURE;
    }
    
    // Interrupt 활성화
    XIntc_Enable(&InterruptController, 0);
    
    // Interrupt Controller 시작
    Status = XIntc_Start(&InterruptController, XIN_REAL_MODE);
    if (Status != XST_SUCCESS) {
        xil_printf("Interrupt Controller start failed\n");
        return XST_FAILURE;
    }
    
    // 프로세서 Interrupt 활성화
    Xil_ExceptionInit();
    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
                                (Xil_ExceptionHandler)XIntc_InterruptHandler,
                                &InterruptController);
    Xil_ExceptionEnable();
    
    xil_printf("System initialized successfully\n");
    xil_printf("BRAM Base: 0x%08X\n", BRAM_BASE_ADDR);
    xil_printf("Start Offset: 0x%04X (Address: 0x%08X)\n", 
               BRAM_START_OFFSET, BRAM_BASE_ADDR + BRAM_START_OFFSET);
    xil_printf("Target Offset: 0x%04X (Address: 0x%08X)\n", 
               BRAM_TARGET_OFFSET, BRAM_BASE_ADDR + BRAM_TARGET_OFFSET);
    xil_printf("Target Pattern: 0x%08X\n", TARGET_PATTERN);
    xil_printf("Waiting for 4-byte packets via UART...\n");
    
    // 초기화 완료 신호를 UART로 전송
    char init_msg[] = "SYSTEM_READY\n";
    XUartLite_Send(&UartLite, (u8*)init_msg, strlen(init_msg));
    
    // 메인 루프 - 4바이트 패킷 수신 및 처리
    while (1) {
        ProcessFourBytes();
        
        // Interrupt 발생 체크
        if (interrupt_occurred) {
            xil_printf("=== Interrupt handled ===\n");
            interrupt_occurred = 0;
        }
    }
    
    return 0;
}

// 테스트용 함수 - 수동으로 타겟 패턴 쓰기
void test_write_target_pattern() {
    xil_printf("Testing: Writing target pattern to target address\n");
    bram_ptr[BRAM_TARGET_OFFSET/4] = TARGET_PATTERN;
    xil_printf("Target pattern written manually\n");
}
