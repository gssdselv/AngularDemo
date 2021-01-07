using MediatR;
using System;
using System.Collections.Generic;
using System.Text;

namespace Flex.APT.Application.Master.Customer
{
    public class GetAllCustomerQuery : IRequest<List<CustomerDto>>
    {

    }
}
