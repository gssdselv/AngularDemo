using Flex.APT.Application.Data_Contract.User;
using Flex.APT.FrameWork.Contract.Cache;
using MediatR;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Flex.APT.Application.User.GetUserDetail
{
    public class GetUserDetailQueryHandler : IRequestHandler<GetUserQuery, List<UserDetailDto>>
    {
        private readonly IUserRepository userRepository;
        private readonly ICacheService cacheService;
        public GetUserDetailQueryHandler(IUserRepository userRepository, ICacheService cacheService)
        {
            this.userRepository = userRepository;
            this.cacheService = cacheService;
        }
        public Task<List<UserDetailDto>> Handle(GetUserQuery request, CancellationToken cancellationToken)
            => Task.FromResult(userRepository.GetUserDetail(request));
        
    }
}
