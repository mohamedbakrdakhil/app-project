"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { createSupabaseBrowserClient } from "@/lib/supabase/browser";
import Button from "@/components/ui/Button";

export default function RegisterPage() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [fullName, setFullName] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setLoading(true);
    const supabase = createSupabaseBrowserClient();
    const { error: authError } = await supabase.auth.signUp({
      email,
      password,
      options: { data: { full_name: fullName } },
    });
    if (authError) {
      setError(authError.message);
      setLoading(false);
      return;
    }
    router.push("/home");
    router.refresh();
  };

  return (
    <div className="space-y-6">
      <div className="text-center">
        <h1 className="text-3xl font-bold" style={{ color: "var(--anatomy)" }}>Masteri</h1>
        <p className="mt-2 text-sm" style={{ color: "var(--text-muted)" }}>Crée ton compte</p>
      </div>
      <form onSubmit={handleSubmit} className="space-y-4">
        <div className="space-y-2">
          <label className="block text-sm font-medium" style={{ color: "var(--text-secondary)" }}>Nom complet</label>
          <input
            type="text"
            value={fullName}
            onChange={(e) => setFullName(e.target.value)}
            className="w-full px-4 py-3 rounded-xl text-sm outline-none"
            style={{ backgroundColor: "var(--bg-card)", border: "1px solid var(--border-soft)", color: "var(--text-primary)" }}
          />
        </div>
        <div className="space-y-2">
          <label className="block text-sm font-medium" style={{ color: "var(--text-secondary)" }}>Email</label>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
            className="w-full px-4 py-3 rounded-xl text-sm outline-none"
            style={{ backgroundColor: "var(--bg-card)", border: "1px solid var(--border-soft)", color: "var(--text-primary)" }}
          />
        </div>
        <div className="space-y-2">
          <label className="block text-sm font-medium" style={{ color: "var(--text-secondary)" }}>Mot de passe</label>
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
            minLength={6}
            className="w-full px-4 py-3 rounded-xl text-sm outline-none"
            style={{ backgroundColor: "var(--bg-card)", border: "1px solid var(--border-soft)", color: "var(--text-primary)" }}
          />
        </div>
        {error && <p className="text-sm" style={{ color: "var(--error)" }}>{error}</p>}
        <Button type="submit" loading={loading} className="w-full">Créer mon compte</Button>
      </form>
      <p className="text-center text-sm" style={{ color: "var(--text-muted)" }}>
        Déjà un compte ?{" "}
        <Link href="/login" style={{ color: "var(--anatomy)" }}>Se connecter</Link>
      </p>
    </div>
  );
}
