# 🛒 Full E-commerce 2026

![Rails Version](https://img.shields.io/badge/rails-v8.1.1-red) ![Ruby Version](https://img.shields.io/badge/ruby-3.4.6-red) ![Tailwind](https://img.shields.io/badge/tailwindcss-v4-blue)

Uma aplicação de E-commerce Fullstack robusta construída com a filosofia "The Rails Way", focada em performance, código limpo e funcionalidades reais de mercado.

## 🚀 Tecnologias

- **Backend:** Ruby on Rails 8.1 (API & MVC)
- **Frontend:** Hotwire (Turbo Drive, Turbo Frames, Turbo Streams), StimulusJS
- **Estilização:** Tailwind CSS v4
- **Database:** PostgreSQL
- **Assets:** Propshaft
- **Pagamentos:** Integração Customizada (Gateway Juno/Iugu - Sandbox)

## ✨ Funcionalidades Principais

### 🛍️ Experiência de Compra
- **Catálogo & Busca:** Navegação fluida por produtos.
- **Carrinho de Compras:** Gerenciamento de itens com persistência.
- **Checkout Sandbox:** Simulação completa de fluxo de pagamento com validações.
- **Recibos Dinâmicos:** Geração de recibos via Modais interativos sem refresh.

### ⚙️ Backend & Integrações
- **Webhook Controller:** Sistema de escuta passiva para confirmação de pagamentos (Machine-to-Machine).
- **Gerenciamento de Pedidos:** Máquina de estados para status de pedido (Aguardando, Pago, Cancelado).
- **Admin Dashboard:** Área restrita para gestão de produtos e métricas.

## 🛠️ Como Rodar o Projeto

1. **Clone o repositório:**
   ```bash
   git clone [https://github.com/seu-usuario/full-ecomme-2026.git](https://github.com/seu-usuario/full-ecomme-2026.git)
   cd full-ecomme-2026

   O Que Temos Até Agora?
Backend: O Webhook recebe o aviso de pagamento e atualiza o banco de dados (payment_accepted).

Infra: O código está no GitHub.

Frontend: Temos o Modal de recibo (HTML/CSS), mas ele ainda não sabe quando aparecer sozinho. O usuário precisa dar F5.