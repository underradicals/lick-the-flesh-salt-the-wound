export type Context = Record<string, any>;

export type Middleware = (ctx: Context, next: () => Promise<void>) => Promise<void>;
const middlewares: Middleware[] = [];

export function Use(mw: Middleware): void {
  middlewares.push(mw);
  return;
}

export async function RunAsync(ctx: Context): Promise<void> {
  const dispatch = (index: number): Promise<void> => {
    if (index >= middlewares.length) return Promise.resolve();

    const middleware = middlewares[index];
    return Promise.resolve(
      middleware(ctx, () => dispatch(index + 1))
    );
  };
  await dispatch(0);
}

// // Logger middleware
// Use(async (ctx, next) => {
//   console.log('Before:', ctx);
//   await next();
//   console.log('After:', ctx);
// });

// // Add data to context
// Use(async (ctx, next) => {
//   ctx.user = { id: 1, name: 'Alice' };
//   await next();
// });

// // Terminal middleware
// Use(async (ctx, next) => {
//   ctx.done = true;
//   await next();
// });

// const ctx: Context = {};
// await RunAsync(ctx);
// console.log('Final Context:', ctx);