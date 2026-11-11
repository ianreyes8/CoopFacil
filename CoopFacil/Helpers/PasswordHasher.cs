using System;
using System.Security.Cryptography;

namespace CoopFacil.Helpers
{
    /// <summary>
    /// Hash de contraseñas con PBKDF2-SHA256 y sal aleatoria por usuario.
    /// Formato guardado: pbkdf2$sha256$iteraciones$sal(base64)$hash(base64)  (unos 90 caracteres).
    /// </summary>
    public static class PasswordHasher
    {
        private const int Iteraciones = 210_000;
        private const int TamanoSal = 16;
        private const int TamanoHash = 32;

        public static string Hashear(string password)
        {
            byte[] sal = RandomNumberGenerator.GetBytes(TamanoSal);
            byte[] hash = Rfc2898DeriveBytes.Pbkdf2(password, sal, Iteraciones, HashAlgorithmName.SHA256, TamanoHash);
            return $"pbkdf2$sha256${Iteraciones}${Convert.ToBase64String(sal)}${Convert.ToBase64String(hash)}";
        }

        public static bool Verificar(string password, string hashGuardado)
        {
            if (string.IsNullOrEmpty(password) || string.IsNullOrEmpty(hashGuardado)) return false;

            string[] partes = hashGuardado.Split('$');
            if (partes.Length != 5 || partes[0] != "pbkdf2" || partes[1] != "sha256") return false;
            if (!int.TryParse(partes[2], out int iteraciones) || iteraciones < 1) return false;

            try
            {
                byte[] sal = Convert.FromBase64String(partes[3]);
                byte[] esperado = Convert.FromBase64String(partes[4]);
                byte[] calculado = Rfc2898DeriveBytes.Pbkdf2(password, sal, iteraciones, HashAlgorithmName.SHA256, esperado.Length);
                return CryptographicOperations.FixedTimeEquals(calculado, esperado);
            }
            catch (FormatException)
            {
                return false;
            }
        }
    }
}
