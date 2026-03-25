using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace RxForEyeIPD.Migrations
{
    /// <inheritdoc />
    public partial class initial : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "user_account_policy",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    user_account_id = table.Column<int>(type: "int", nullable: false),
                    user_policy = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    is_enabled = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_user_account_policy", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "user_accounts",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    user_name = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    password = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    role = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_user_accounts", x => x.Id);
                });

            migrationBuilder.InsertData(
                table: "user_account_policy",
                columns: new[] { "id", "is_enabled", "user_account_id", "user_policy" },
                values: new object[,]
                {
                    { 1, true, 1, "VIEW_PRODUCT" },
                    { 2, false, 1, "ADD_PRODUCT" },
                    { 3, true, 1, "EDIT_PRODUCT" },
                    { 4, false, 1, "DELETE_PRODUCT" },
                    { 5, false, 2, "VIEW_PRODUCT" },
                    { 6, false, 2, "ADD_PRODUCT" },
                    { 7, true, 2, "EDIT_PRODUCT" },
                    { 8, true, 2, "DELETE_PRODUCT" }
                });

            migrationBuilder.InsertData(
                table: "user_accounts",
                columns: new[] { "Id", "password", "role", "user_name" },
                values: new object[,]
                {
                    { 1, "123", "Admin", "Rasel" },
                    { 2, "123", "User", "Rubel" }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "user_account_policy");

            migrationBuilder.DropTable(
                name: "user_accounts");
        }
    }
}
