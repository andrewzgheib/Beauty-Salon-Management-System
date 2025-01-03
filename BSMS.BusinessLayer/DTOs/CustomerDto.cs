﻿namespace BSMS.BusinessLayer.DTOs
{
    public class CustomerDto
    {
        public string CustomerFn { get; set; } = null!;
        public string CustomerLn { get; set; } = null!;
        public string? CustomerEmail { get; set; }
        public string? CustomerPn { get; set; }
        public DateOnly CustomerDob { get; set; }
        public PronounDto CustomerPronoun { get; set; } = null!;
        public bool Promotions { get; set; }
        public string? CustomerPfp { get; set; }
        public bool IsGoogle { get; set; }
        public bool IsApple { get; set; }
        public bool Is2fa { get; set; }

    }
}
