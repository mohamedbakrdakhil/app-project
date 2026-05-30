"use client";
import { useRouter } from "next/navigation";
import { createSupabaseBrowserClient } from "@/lib/supabase/browser";
import Button from "@/components/ui/Button";

export default function LogoutButton() {
  const router = useRouter();
  const handleLogout = async () => {
    const supabase = createSupabaseBrowserClient();
    await supabase.auth.signOut();
    router.push("/login");
    router.refresh();
  };
  return (
    <Button variant="secondary" onClick={handleLogout} className="w-full">
      Se déconnecter
    </Button>
  );
}
