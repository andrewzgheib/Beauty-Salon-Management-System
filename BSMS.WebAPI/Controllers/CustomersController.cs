﻿using BSMS.BusinessLayer.Commands;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BSMS.WebAPI.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class CustomersController : ControllerBase
    {
        private readonly IMediator _mediator;

        public CustomersController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpPost("register")]
        public async Task<IActionResult> RegisterCustomer(CreateCustomerCommand command)
        {
            return Ok(await _mediator.Send(command));
        }

        [HttpPost("address")]
        public async Task<IActionResult> AddCustomerAddress(CreateCustomerAddressCommand command)
        {
            return Ok(await _mediator.Send(command));

        }

        [HttpPost("preferences")]
        public async Task<IActionResult> CreateCustomerPreferences(CreateCustomerPreferenceCommand command)
        {
            return Ok(await _mediator.Send(command));

        }

    }
}
