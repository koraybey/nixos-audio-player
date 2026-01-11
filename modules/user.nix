{userConfig, ...}: {
  users.users.${userConfig.username} = {
    isNormalUser = true;
    extraGroups = userConfig.groups;
    # Password authentication disabled - SSH key authentication only
    # sudo still requires password as security.sudo.wheelNeedsPassword is set to true
    # To set a password after deployment: sudo passwd admin
    initialPassword = "changeme";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDBbC6H4YbObdwyhB62DCtsaCtNyXaj8Ou4Xf4y8VHRs5YJrJ/jy9TJqT7ibWKpLcR/HNq6zr9fQp3VkFV3r6/o70OL0Npb9mshbMFX7SxqlfPSpkOnt0kka0V8nNCw5vrTup9M9isxLnQUW0vsNWYftXkYOZR8mvv/OM3EAqk2PkPAJxs3IYqLfH52iCLAinLYRrnjaXIw9UWzqLNLHSAk6rHnTvlWWfdmltNt5yFyLN6lCIoIRSPvjJAJAzEYTHn0gf4r19raLU1BoUFsoB/RfO+4QhU6jhJGwRdbj7kytmkaLBrc3RPqGgr2JNdwNp6A4SQh2bXeg1EqNPLD4aBD4kZ1i6YuuIZ4SA4DbcOCgXrfIzeB0AavaRXjaKnPVDjkVwEh8cUXOCJLXZIV2eOOA6L4t52R25OQKMadbEy41tFqZpDZ7arWkBQRTn1jybpvjiT+Urt8Bbqffvc8bATMn85UFJZ3EDWpI0eh0ottRyxPNfnXRWozR4ohPCEXXWVOnqOgWc2kLvzAw3zRSB2AgYVLiKy+DIBwskNcKRk5nYp8brQKO/aA1nD15F35Wo3GE6mSlGfIB5t/P1SIRbe7DZ9H7pdCK1HI4cdyPGu+WJiG43e2WD8+5lUSZ2DdGCurZLCRGQq/36MYr2thOBJFq4K1YSI7sc1foJq0c36PTw== hello@koray.onl"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLz39d0BurU2U3VUhxkzV0wDr2NYxKeRgYozSYIxqzBX+bqFjRfdJz7PMg7b5EknFSCCk3GSc8Pi49fbdQqlAXo= gkropitz@GBook14"
    ];
  };
}
