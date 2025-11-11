/**
 * Emscripten Compatibility Fixes for PDF-Writer
 *
 * This header provides workarounds for Emscripten/libc++ compatibility issues
 */

#ifndef EMSCRIPTEN_FIXES_H
#define EMSCRIPTEN_FIXES_H

#ifdef __EMSCRIPTEN__

#include <string>

// Provide char_traits specialization for unsigned char
// This is needed because PDF-Writer uses std::basic_string<unsigned char>
namespace std {
    template<>
    struct char_traits<unsigned char> {
        typedef unsigned char char_type;
        typedef int int_type;
        typedef streamoff off_type;
        typedef streampos pos_type;
        typedef mbstate_t state_type;

        static void assign(char_type& c1, const char_type& c2) {
            c1 = c2;
        }

        static char_type* assign(char_type* s, size_t n, char_type a) {
            for (size_t i = 0; i < n; ++i) {
                s[i] = a;
            }
            return s;
        }

        static bool eq(char_type c1, char_type c2) {
            return c1 == c2;
        }

        static bool lt(char_type c1, char_type c2) {
            return c1 < c2;
        }

        static int compare(const char_type* s1, const char_type* s2, size_t n) {
            for (size_t i = 0; i < n; ++i) {
                if (s1[i] < s2[i]) return -1;
                if (s1[i] > s2[i]) return 1;
            }
            return 0;
        }

        static size_t length(const char_type* s) {
            size_t len = 0;
            while (s[len] != char_type()) {
                ++len;
            }
            return len;
        }

        static const char_type* find(const char_type* s, size_t n, const char_type& a) {
            for (size_t i = 0; i < n; ++i) {
                if (s[i] == a) {
                    return s + i;
                }
            }
            return nullptr;
        }

        static char_type* move(char_type* s1, const char_type* s2, size_t n) {
            if (s1 < s2) {
                for (size_t i = 0; i < n; ++i) {
                    s1[i] = s2[i];
                }
            } else if (s2 < s1) {
                for (size_t i = n; i > 0; --i) {
                    s1[i - 1] = s2[i - 1];
                }
            }
            return s1;
        }

        static char_type* copy(char_type* s1, const char_type* s2, size_t n) {
            for (size_t i = 0; i < n; ++i) {
                s1[i] = s2[i];
            }
            return s1;
        }

        static char_type to_char_type(int_type c) {
            return static_cast<char_type>(c);
        }

        static int_type to_int_type(char_type c) {
            return static_cast<int_type>(c);
        }

        static bool eq_int_type(int_type c1, int_type c2) {
            return c1 == c2;
        }

        static int_type eof() {
            return static_cast<int_type>(-1);
        }

        static int_type not_eof(int_type c) {
            return (c == eof()) ? 0 : c;
        }
    };
}

#endif // __EMSCRIPTEN__

#endif // EMSCRIPTEN_FIXES_H
