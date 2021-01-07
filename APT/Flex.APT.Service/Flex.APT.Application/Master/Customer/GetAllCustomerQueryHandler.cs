using Flex.APT.Application.Data_Contract.Master.Customer;
using Flex.APT.FrameWork.Contract.Cache;
using Flex.APT.FrameWork.Resources;
using MediatR;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Flex.APT.Application.Master.Customer
{
    public class GetAllCustomerQueryHandler : IRequestHandler<GetAllCustomerQuery, List<CustomerDto>>
    {
        private readonly ICacheService CacheService;
        private readonly ICustomerRepository CustomerRepository;
        public GetAllCustomerQueryHandler(ICacheService cacheService, ICustomerRepository CustomerRepository)
        {
            this.CacheService = cacheService;
            this.CustomerRepository = CustomerRepository;
        }

        public Task<List<CustomerDto>> Handle(GetAllCustomerQuery request, CancellationToken cancellationToken)
            => Task.FromResult(this.CacheService.GetOrCreate(ConstantResources.Cache_GetAllCustomer,() => CustomerRepository.GetAllCustomer()));
    }
}
