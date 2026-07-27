local source = {}

local entries = {}

local kinds = {
  Keyword = 14,
  Variable = 6,
  Constant = 21,
}

local function add(words, kind, detail)
  for _, word in ipairs(words) do
    entries[#entries + 1] = { word = word, kind = kind, detail = detail }
  end
end

add({
  "adc", "add", "adiw", "and", "andi", "asr", "bclr", "bld", "brbc", "brbs", "brcc", "brcs",
  "break", "breq", "brge", "brhc", "brhs", "brid", "brie", "brlo", "brlt", "brmi", "brne",
  "brpl", "brsh", "brtc", "brts", "brvc", "brvs", "bset", "bst", "call", "cbi", "cbr", "clc",
  "clh", "cli", "cln", "cls", "clt", "clv", "clz", "com", "cp", "cpc", "cpi", "cpse", "dec",
  "eicall", "eijmp", "elpm", "eor", "fmul", "fmuls", "fmulsu", "icall", "ijmp", "in", "inc",
  "jmp", "ld", "ldd", "ldi", "lds", "lpm", "lsl", "lsr", "mov", "movw", "mul", "muls", "mulsu",
  "neg", "nop", "or", "ori", "out", "pop", "push", "rcall", "ret", "reti", "rjmp", "rol", "ror",
  "sbc", "sbci", "sbi", "sbr", "sbrc", "sbrs", "sec", "seh", "sei", "sen", "ser", "ses", "set",
  "sev", "sez", "sleep", "spm", "st", "std", "sts", "sub", "subi", "swap", "tst", "wdr", "xch",
}, kinds.Keyword, "AVR instruction")

add({
  "r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7", "r8", "r9", "r10", "r11", "r12", "r13",
  "r14", "r15", "r16", "r17", "r18", "r19", "r20", "r21", "r22", "r23", "r24", "r25", "r26",
  "r27", "r28", "r29", "r30", "r31", "X", "Y", "Z", "XL", "XH", "YL", "YH", "ZL", "ZH",
}, kinds.Variable, "AVR register")

add({
  "PINB", "DDRB", "PORTB", "PINC", "DDRC", "PORTC", "PIND", "DDRD", "PORTD",
  "TCCR0A", "TCCR0B", "TCNT0", "OCR0A", "OCR0B", "TIMSK0", "TIFR0",
  "TCCR1A", "TCCR1B", "TCNT1H", "TCNT1L", "OCR1AH", "OCR1AL", "OCR1A", "OCR1BH", "OCR1BL",
  "OCR1B", "ICR1H", "ICR1L", "ICR1", "TIMSK1", "TIFR1",
  "TCCR2A", "TCCR2B", "TCNT2", "OCR2A", "OCR2B", "TIMSK2", "TIFR2",
  "UDR0", "UCSR0A", "UCSR0B", "UCSR0C", "UBRR0H", "UBRR0L",
  "SREG", "SPH", "SPL", "EIMSK", "EIFR", "PCICR", "PCMSK0", "PCMSK1", "PCMSK2",
  "ADCSRA", "ADCSRB", "ADMUX", "ADCL", "ADCH", "DIDR0", "ACSR", "SMCR", "MCUCR", "MCUSR",
  "WDTCSR", "PRR", "GPIOR0", "GPIOR1", "GPIOR2", "EECR", "EEDR", "EEARH", "EEARL",
}, kinds.Constant, "ATmega328P SFR")

source.new = function()
  return source
end

source.is_available = function()
  return vim.bo.filetype == "asm"
end

source.get_trigger_characters = function()
  return {}
end

source.complete = function(_, params, callback)
  local prefix = params.context.cursor_before_line:match("[%w_]+$") or ""
  if prefix == "" then
    callback({ items = {}, isIncomplete = false })
    return
  end

  local prefix_lower = prefix:lower()
  local results = {}

  for _, entry in ipairs(entries) do
    if entry.word:lower():sub(1, #prefix_lower) == prefix_lower then
      results[#results + 1] = {
        label = entry.word,
        insertText = entry.word,
        kind = entry.kind,
        detail = entry.detail,
      }
    end
  end

  callback({ items = results, isIncomplete = false })
end

return source
