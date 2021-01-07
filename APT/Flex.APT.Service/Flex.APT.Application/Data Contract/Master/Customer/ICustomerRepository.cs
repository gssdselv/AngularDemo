using Flex.APT.Application.Master.Customer;
using System;
using System.Collections.Generic;
using System.Text;

namespace Flex.APT.Application.Data_Contract.Master.Customer
{
    public interface ICustomerRepository
    {
        List<CustomerDto> GetAllCustomer();
    }
}
