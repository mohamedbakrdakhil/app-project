import Header from "./Header";
import BottomNav from "./BottomNav";

export default function AppShell({ children }: { children: React.ReactNode }) {
  return (
    <div className="min-h-screen flex flex-col" style={{ backgroundColor: "var(--bg-primary)" }}>
      <Header />
      <main className="flex-1 pb-20 px-4 max-w-lg mx-auto w-full pt-4">
        {children}
      </main>
      <BottomNav />
    </div>
  );
}
