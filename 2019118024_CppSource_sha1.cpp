
//201918024 백종인
//디지털 설계 SHA1 알고리즘

#include <iostream>
#include <stdint.h>
using namespace std;


#define rotate_shift(bits,word) (((word) << (bits)) | ((word) >> (32-(bits))))


uint32_t h[5] = {
     0x67452301
    ,0xEFCDAB89
    ,0x98BADCFE
    ,0x10325476
    ,0xC3D2E1F0
};

uint32_t convert(char ch) {
    uint32_t val;
    switch (ch)
    {
    case '0': val = 0x0; break;
    case '1': val = 0x1; break;
    case '2': val = 0x2; break;
    case '3': val = 0x3; break;
    case '4': val = 0x4; break;
    case '5': val = 0x5; break;
    case '6': val = 0x6; break;
    case '7': val = 0x7; break;
    case '8': val = 0x8; break;
    case '9': val = 0x9; break;
    case 'A': val = 0x10; break;
    case 'B': val = 0x11; break;
    case 'C': val = 0x12; break;
    case 'D': val = 0x13; break;
    case 'E': val = 0x14; break;
    case 'F': val = 0x15; break;

    default:
        break;
    }
    
    return val;
}


int main(void) {
   
    string str;

    cin >> str;

    uint32_t W[80];
    uint32_t M[129];
    for (int i = 0; i < 128; i++) {
        M[i] = convert(str[i]);
    }

    int cnt = 0;
    

    //W[0] ~ W[15] 계산
    for (int i = 0; i < str.size(); i += 8) {
        W[cnt++] = (M[i] << 28) | (M[i + 1] << 24) | (M[i + 2] << 20) | (M[i + 3] << 16) | (M[i + 4] << 12) |
            (M[i + 5] << 8) | (M[i + 6] << 4) | (M[i + 7]);
    }

    for (int i = 16; i < 80; i++) {
        W[i] = (W[i - 3] ^ W[i - 8] ^ W[i - 14] ^ W[i - 16]);
        W[i] = rotate_shift(1,W[i]);
    }

    uint32_t a = h[0];
    uint32_t b = h[1];
    uint32_t c = h[2];
    uint32_t d = h[3];
    uint32_t e = h[4];

    uint32_t f, k;


    //a, b, c, d, e 값 검사

    for (int i = 0; i < 80; i++) {

        if (0<= i && i<=19) {
            f = (b & c) | ((~b) & d);
            k = 0x5A827999;
        }

        else if (20 <= i && i <= 39) {
            f = b ^ c ^ d;
            k = 0x6ED9EBA1;
        }


        else if (40 <=i && i <= 59) {
            f = ((b & c) | (b & d) | (c & d));
            k = 0x8F1BBCDC;
        }


        else if(60 <= i && i<= 79) {
            f = b ^ c ^ d;
            k = 0xCA62C1D6;
        }

        uint32_t temp = (rotate_shift(5,a) + f + e + k + W[i]);
        e = d;
        d = c;
        c = rotate_shift(30,b);
        b = a;
        a = temp;

      
        if (i == 19) {
            cout << hex << "Round 1 --> " << "A: " << a << " B: " << b << " C: " << c << " D: " << d << " E: " << e << '\n';
        }

        if (i == 39) {
            cout << hex << "Round 2 --> " << "A: " << a << " B: " << b << " C: " << c << " D: " << d << " E: " << e << '\n';
        }

        if (i == 59) {
            cout << hex << "Round 3 --> " << "A: " << a << " B: " << b << " C: " << c << " D: " << d << " E: " << e << '\n';
        }

        if (i == 79) {
            cout << hex << "Round 4 --> " << "A: " << a << " B: " << b << " C: " << c << " D: " << d << " E: " << e << '\n';
        }
        

    }

    h[0] = h[0] + a;
    h[1] = h[1] + b;
    h[2] = h[2] + c;
    h[3] = h[3] + d;
    h[4] = h[4] + e;

    cout << "result : ";
    for (int i = 0; i < 5; i++) {
        cout << h[i];
    }

    return 0;
}