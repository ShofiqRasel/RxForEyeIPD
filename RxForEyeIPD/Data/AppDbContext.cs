using RxForEyeIPD.Model.Entities;
using Microsoft.EntityFrameworkCore;

namespace RxForEyeIPD.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions dbContextOptions) : base(dbContextOptions)
        {
        }


        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            var demoUserAccount = new UserAccount[]
            {
               new UserAccount { Id = 1, UserName = "Rasel", Password = "123", Role="Admin" },
               new UserAccount { Id = 2, UserName = "Rubel", Password = "123", Role="User" }
            };
            modelBuilder.Entity<UserAccount>().HasData(demoUserAccount);

            var demoUserAccountPolicy = new UserAccountPolicy[]
                {
                    new UserAccountPolicy { Id = 1, UserAccountId = 1, UserPolicy = UserPolicy.VIEW_PRODUCT.ToString(), IsEnabled=true },
                    new UserAccountPolicy { Id = 2, UserAccountId = 1, UserPolicy = UserPolicy.ADD_PRODUCT.ToString(), IsEnabled=false },
                    new UserAccountPolicy { Id = 3, UserAccountId = 1, UserPolicy = UserPolicy.EDIT_PRODUCT.ToString(), IsEnabled=true },
                    new UserAccountPolicy { Id = 4, UserAccountId = 1, UserPolicy = UserPolicy.DELETE_PRODUCT.ToString(), IsEnabled=false },

                    new UserAccountPolicy { Id = 5, UserAccountId = 2, UserPolicy = UserPolicy.VIEW_PRODUCT.ToString(), IsEnabled=false },
                    new UserAccountPolicy { Id = 6, UserAccountId = 2, UserPolicy = UserPolicy.ADD_PRODUCT.ToString(), IsEnabled=false },
                    new UserAccountPolicy { Id = 7, UserAccountId = 2, UserPolicy = UserPolicy.EDIT_PRODUCT.ToString(), IsEnabled=true },
                    new UserAccountPolicy { Id = 8, UserAccountId = 2, UserPolicy = UserPolicy.DELETE_PRODUCT.ToString(), IsEnabled=true }
                };
            modelBuilder.Entity<UserAccountPolicy>().HasData(demoUserAccountPolicy);
        }


        public DbSet<UserAccount> UserAccounts { get; set; }
        public DbSet<UserAccountPolicy> UserAccountPolicies { get; set; }
    }
}
