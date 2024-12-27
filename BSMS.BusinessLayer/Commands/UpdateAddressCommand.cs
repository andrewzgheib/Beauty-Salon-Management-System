﻿using MediatR;

namespace BSMS.BusinessLayer.Commands
{
    public class UpdateAddressCommand : IRequest<Unit>
    {
        public int AddressId { get; set; }
        public string AddressStreet { get; set; } = null!;
        public string AddressBuilding { get; set; } = null!;
        public string AddressFloor { get; set; } = null!;
        public string? AddressNotes { get; set; }
        public int City { get; set; }
    }
}