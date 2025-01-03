﻿using BSMS.Data.Common.Interfaces;
using BSMS.PostgreSQL.Repositories;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace BSMS.PostgreSQL
{
    public static class Dependencies
    {
        public static IServiceCollection AddPostgreSQLDependencies(this IServiceCollection services, IConfiguration configuration)
        {
            var connectionString = configuration.GetConnectionString("DefaultConnection");

            services.AddDbContext<BSMSDbContext>(options =>
                options.UseNpgsql(connectionString));

            services.AddScoped<ICityRepository>(sp =>
                        new CityRepository(connectionString));

            services.AddScoped<IBundleRepository, BundleRepository>();

            services.AddScoped<IAddressRepository, AddressRepository>();

            services.AddScoped<ICustomerRepository, CustomerRepository>();

            services.AddScoped<IPronounRepository, PronounRepository>();

            services.AddScoped<IPreferenceRepository, PreferenceRepository>();

            services.AddScoped<ICustomerAddressRepository, CustomerAddressRepository>();

            services.AddScoped<ICustomerPreferenceRepository, CustomerPreferenceRepository>();


            return services;
        }
    }
}
